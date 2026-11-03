setwd("C:/Users/jgera/Dropbox/PC (6)/Desktop/romanian_ac")
library(plyr)
library(lmerTest)
library(emmeans)
source("C:/Users/jgera/Dropbox/UMD/research/adjuncts/data analysis/summarySE.r")
source("C:/Users/jgera/Dropbox/UMD/research/adjuncts/data analysis/multiplot.r")
library(ggplot2)
library(extrafont)
library(reshape2)

options(scipen = 999)

i=1
subject_i = 1
subject = c()
fillers = read.csv("filler_grammaticality_eng.csv", header=TRUE)

#NEW: one filler is worded differently in the new task ("scheduled" vs "made" the appointments): make sure both wordings are in the filler list
for(pair in list(c("made the appointments","scheduled the appointments"), c("scheduled the appointments","made the appointments"))){
  has_from = grepl(pair[1], fillers$sentence)
  if(any(has_from) & !any(grepl(pair[2], fillers$sentence))){
    new_row = fillers[which(has_from)[1],]
    new_row$sentence = sub(pair[1], pair[2], new_row$sentence)
    fillers = rbind(fillers, new_row)
  }
}

#NEW: which version of the task each file comes from (filled in below)
file_versions = c()

for (i in 1:length(dir("eng_gram/"))){
  file = paste("eng_gram/",dir("eng_gram/")[i],sep="")
  temp = read.csv(file, header = TRUE)
  #NEW: files from the new task have a "platform" column; the older files do not
  file_version = ifelse("platform" %in% colnames(temp), "new", "original")
  
  #remove instructions and training items
  temp = subset(temp, condition !="training"& condition != "")
  
  #clean HTML format
  temp$stimulus = gsub('.*Ok: <br><br>', '', temp$stimulus)
  temp$stimulus = gsub('<br><br></div>', '', temp$stimulus)
  
  #add trial numbers
  temp$trial_index = (temp$trial_index - 5)
  
  #add filler grammaticality
  temp$filler_gram = fillers[match(temp$stimulus, fillers$sentence),]$grammaticality
  
  #make item column based on the verb
  temp$item = sapply(strsplit(
    unlist(lapply(temp$stimulus, FUN = split, " "))," "), 
    function(words) words[3])
  
  #split conditions column into 4 categories
  temp_condition = as.data.frame(
    t(
      as.data.frame(
        strsplit(unlist(lapply(temp$condition, FUN = split, " ")),"_"))))
  
  #name the 4 categories: number of the subject, number of the object, match/mismatch, and grammatical/ungrammatical
  colnames(temp_condition) = c("subj_num","subj_gender","match_mismatch","gram_ungram")
  
  temp = cbind(temp, temp_condition)
  
  #add subject id based on file name
  temp$subject = as.factor(gsub(".csv",
                                "",
                                gsub("eng_gram/",
                                     "",
                                     file)))
  file_versions[as.character(temp$subject[1])] = file_version   #NEW: remember the version of this participant
  
  temp$z_rating = (temp$response - mean(temp$response, na.rm = TRUE))/sd(temp$response, na.rm = TRUE)
  
  if(i==1){
    data = as.data.frame(matrix(nrow=0,ncol=ncol(temp)))
  }else{
    #NEW: files from the new task (jsPsych 8) lack some columns of the older files (e.g. internal_node_id) and have extra ones;
    #     add the missing ones as NA so that every file ends up with the same columns as the first (older) file
    for(missing_col in setdiff(colnames(data), colnames(temp))) temp[[missing_col]] = NA
    temp = subset(temp, select = c(colnames(data)))
  }
  
  data = rbind(data, temp)
}

data$language = "English"

test_data = subset(data, condition != "filler")
filler_data = subset(data, condition == "filler")

library(viridis)   # for perceptually-uniform ramps

cols <- viridis(101,            # 101 = 0…100 inclusive
                option    = "viridis",   # or "magma", "viridis", "turbo", …
                direction = -1)         # darkest = 0, lightest = 100
names(cols) <- 0:100                     # name the vector so levels line up


ggplot(data,                     # one row = one judgment
       aes(x   = subject,        # one bar per participant
           fill = as.factor(response))) +   # colour by the 0-100 score
  geom_bar(position = "stack") +
  scale_fill_manual(
    values = cols,
    name   = "Judgment (0–100)"
  )



test_data$match_mismatch = as.factor(test_data$match_mismatch)
test_data$gram_ungram = as.factor(test_data$gram_ungram)
test_data$subj_num = as.factor(test_data$subj_num)

#find average responses for test and filler items
test_subject_averages = summarySE(data = test_data, measurevar = "response", groupvars = c("subject","match_mismatch","gram_ungram"))
filler_subject_averages = summarySE(data = filler_data, measurevar = "response", groupvars = c("subject","filler_gram"))

#categorize participants based on whether they were paying attention to the gender manipulation - categories from filler ratings
casted_fillers = dcast(filler_subject_averages, subject ~ filler_gram, value.var = "response")

casted_fillers$response_category <- as.factor(ifelse(casted_fillers$G >= 70 & casted_fillers$U <= 30, "included",
                                                     ifelse(casted_fillers$U > 30 & casted_fillers$G > 70, "yes_bias",
                                                            ifelse(casted_fillers$G < 70 & casted_fillers$U < 30, "no_bias",
                                                                   ifelse(casted_fillers$G < 70 & casted_fillers$U > 30, "guessing",
                                                                          "uncategorized")))))
#add categorizations to filler df
filler_subject_averages <- merge(filler_subject_averages, 
                                 casted_fillers[, c("subject", "response_category")], 
                                 by = "subject", all.x = TRUE)

#add categorizations to test df
test_subject_averages <- merge(test_subject_averages, 
                               casted_fillers[, c("subject", "response_category")], 
                               by = "subject", all.x = TRUE)

test_averages = summarySE(data = test_subject_averages, measurevar = "response", groupvars = c("match_mismatch","gram_ungram","response_category"), na.rm=TRUE)
filler_averages = summarySE(data = filler_subject_averages, measurevar = "response", groupvars = c("filler_gram","response_category"))

#repeat categorization for z-scored ratings, with cutoffs based on grammatical ratings < 2sd below filler mean, and ungramm > 2sd above
test_subject_averages_z = summarySE(data = test_data, measurevar = "z_rating", groupvars = c("subject","match_mismatch","gram_ungram"))
filler_subject_averages_z = summarySE(data = filler_data, measurevar = "z_rating", groupvars = c("subject","filler_gram"))

casted_fillers_z = dcast(filler_subject_averages_z, subject ~ filler_gram, value.var = "z_rating")

gram_cutoff = mean(casted_fillers_z$G) - 2*sd(casted_fillers_z$G)
ungram_cutoff = mean(casted_fillers_z$U) + 2*sd(casted_fillers_z$U)

casted_fillers_z$response_category <- as.factor(ifelse(casted_fillers_z$G >= gram_cutoff & casted_fillers_z$U <= ungram_cutoff, "included",
                                                       ifelse(casted_fillers_z$U > ungram_cutoff & casted_fillers_z$G > gram_cutoff, "yes_bias",
                                                              ifelse(casted_fillers_z$G < gram_cutoff & casted_fillers_z$U < ungram_cutoff, "no_bias",
                                                                     ifelse(casted_fillers_z$G < gram_cutoff & casted_fillers_z$U > ungram_cutoff, "guessing",
                                                                            "uncategorized")))))

#add categorizations to filler df
filler_subject_averages_z <- merge(filler_subject_averages_z, 
                                   casted_fillers_z[, c("subject", "response_category")], 
                                   by = "subject", all.x = TRUE)

#add categorizations to test df
test_subject_averages_z <- merge(test_subject_averages_z, 
                                 casted_fillers_z[, c("subject", "response_category")], 
                                 by = "subject", all.x = TRUE)


test_averages_z = summarySE(data = test_subject_averages_z, measurevar = "z_rating", groupvars = c("match_mismatch","gram_ungram","response_category"), na.rm=TRUE)
filler_averages_z = summarySE(data = filler_subject_averages_z, measurevar = "z_rating", groupvars = c("filler_gram","response_category"))


#set Z value: z = 0 for raw ratings, z = 1 for z-scored ratings
z = 1

if(z==0){
  
  test_df = test_averages
  test_subject_df = test_subject_averages
  
  filler_df = filler_averages
  filler_subject_df = filler_subject_averages
  y_limits = c(0,100)
  
}else{
  test_df = test_averages_z
  test_df$response = test_df$z_rating
  test_subject_df = test_subject_averages_z
  test_subject_df$response = test_subject_df$z_rating
  
  filler_df = filler_averages_z
  filler_df$response = filler_averages_z$z_rating
  filler_subject_df = filler_subject_averages_z
  filler_subject_df$response = filler_subject_df$z_rating
  y_limits = c(-1.25,1.25)
}

eng_test_plot = ggplot(subset(test_df, response_category == "included"),
       aes(y = response, fill = match_mismatch, x=gram_ungram))+
  geom_bar(stat="identity",position=position_dodge(), colour="black") +
  geom_errorbar(aes(ymin=(response)-se, ymax=(response)+se),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9))+
  geom_dotplot(data = subset(test_subject_df, response_category == "included"),
               binaxis='y', stackdir='center', dotsize=.3,position=position_dodge())+
  #scale_fill_manual(values= c("grey","white"))+
  scale_fill_manual(values= c("#e79f00","#9ad0f3"),
                    name="subject/object\nnumber match")+
  scale_x_discrete(name="grammaticality\n(gender match with antecedent)",
                   labels = c("grammatical\n\"the boy... HIMself",
                              "ungrammatical\n\"the boy... HERself")
  )+
  ylab("acceptability rating")+
  ggtitle("English z-score ratings")+
  scale_y_continuous(limits = y_limits)+
  theme_bw()+
  theme(text=element_text(size=15,
                          family="Arial"))


test_subject_averages_rt = summarySE(data = subset(test_data, subject %in% subset(test_subject_averages, response_category=="included")$subject), 
                                     measurevar = "rt", groupvars = c("subject","match_mismatch","gram_ungram"))
test_subject_averages_rt$log_rt = log(test_subject_averages_rt$rt)

test_averages_rt = summarySE(data = test_subject_averages_rt, measurevar = "log_rt", groupvars = c("match_mismatch","gram_ungram"))

eng_test_plot_rt = ggplot(test_averages_rt,
                          aes(y = log_rt, x = match_mismatch, fill=gram_ungram))+
  geom_bar(stat="identity",position=position_dodge(), colour="black") +
  coord_cartesian(ylim = c(8,10))+
  scale_y_continuous()+
  geom_errorbar(aes(ymin=(log_rt)-se, ymax=(log_rt)+se),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9))+
  geom_dotplot(data = test_subject_averages_rt,
               binaxis='y', stackdir='center', dotsize=.3,position=position_dodge())+
  #scale_fill_manual(values= c("grey","white"))+
  scale_fill_manual(values= c("#e79f00","#9ad0f3")
                    )+
  scale_x_discrete(name="grammaticality\n(gender match with antecedent)",
                   labels = c("grammatical\n\"the boy... adj-M",
                              "ungrammatical\n\"the boy... adj-F")
  )+
  ylab("log rt")+
  ggtitle("English log RTs")+
  theme_bw()+
  theme(text=element_text(size=15,
                          family="Arial"))

eng_filler_plot = ggplot(subset(filler_df, response_category == "included"),
       aes(y = response, x=filler_gram))+
  geom_bar(stat="identity",position=position_dodge(), colour="black") +
  geom_errorbar(aes(ymin=(response)-se, ymax=(response)+se),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9))+
  geom_dotplot(data = subset(filler_subject_df, response_category == "included"),
               binaxis='y', stackdir='center', dotsize=.5,position=position_dodge())+
  scale_x_discrete(name="grammaticality\n(gender match with antecedent)",
                   labels = c("grammatical\n\"the boy... adj-M",
                              "ungrammatical\n\"the boy... adj-F")
  )+
  ylab("acceptability rating")+
  scale_y_continuous(limits = y_limits)+
  theme_bw()+
  theme(text=element_text(size=15,
                          family="Arial"))


eng_data = cbind(test_data, 
                 response_category = test_subject_averages[match(test_data$subject, test_subject_averages$subject),]$response_category,
                 response_category_z = test_subject_averages_z[match(test_data$subject, test_subject_averages_z$subject),]$response_category)

eng_fillers =  cbind(filler_subject_df, language = "English")

#NEW: copies of eng_data and eng_fillers with a column that says whether the participant did the original or the new version of the task.
#     eng_data and eng_fillers (above) are unchanged: those are the ones to merge with the Romanian data.
eng_data_version = cbind(eng_data, version = unname(file_versions[as.character(eng_data$subject)]))
eng_fillers_version = cbind(eng_fillers, version = unname(file_versions[as.character(eng_fillers$subject)]))