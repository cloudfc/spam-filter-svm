%% Machine Learning - Spam Classification with SVMs
%% Using data subset of the SpamAssassin Public Corpus
%% For more info on the data see http://spamassassin.apache.org/old/publiccorpus/


%% Initialization
clear ; close all; clc

%% ========================= Email Preprocessing ======================
%  To use an SVM to classify emails into Spam v.s. Non-Spam, 
%  first convert each email into a vector of features
%  implement the preprocessing steps for each email
%  use processEmail.m to produce a word indices vector for a given email

fprintf('\nPreprocessing sample email (emailSample1.txt)\n');

% Extract Features
file_contents = readFile('emailSample1.txt');
word_indices  = processEmail(file_contents);

% Print Stats
fprintf('Word Indices: \n');
fprintf(' %d', word_indices);
fprintf('\n\n');

fprintf('Program paused. Press enter to continue.\n');
pause;

%% ======================= Feature Extraction =========================
%  convert each email into a vector of features in R^n
%  use code in emailFeatures.m to produce a feature vector for a given email

fprintf('\nExtracting features from sample email (emailSample1.txt)\n');

% Extract Features
file_contents = readFile('emailSample1.txt');
word_indices  = processEmail(file_contents);
features      = emailFeatures(word_indices);

% Print Stats
fprintf('Length of feature vector: %d\n', length(features));
fprintf('Number of non-zero entries: %d\n', sum(features > 0));

fprintf('Program paused. Press enter to continue.\n');
pause;

%% =============== Train Linear SVM for Spam Classification ============
%  train a linear classifier to determine if an email is Spam or Not-Spam

% Load the Spam Email dataset
% You will have X, y in your environment
load('spamTrain.mat');

fprintf('\nTraining Linear SVM (Spam Classification)\n')
fprintf('(this may take 1 to 2 minutes) ...\n')

C = 0.1;
model = svmTrain(X, y, C, @linearKernel);

p = svmPredict(model, X);

fprintf('Training Accuracy: %f\n', mean(double(p == y)) * 100);

%% ======================= Test Spam Classification ====================
%  evaluate it on a test set (test set in spamTest.mat)

% Load the test dataset
% You will have Xtest, ytest in your environment
load('spamTest.mat');

fprintf('\nEvaluating the trained Linear SVM on a test set ...\n')

p = svmPredict(model, Xtest);

fprintf('Test Accuracy: %f\n', mean(double(p == ytest)) * 100);
pause;


%% ===================== Top Predictors of Spam ========================
%  Since the model we are training is a linear SVM, we can inspect the
%  weights learned by the model to understand better how it is determining
%  whether an email is spam or not. 
%  finds the words with the highest weights in the classifier. 
%  Informally, the classifier 'thinks' that these words are the most likely indicators of spam.
%

% Sort the weights and obtin the vocabulary list
[weight, idx] = sort(model.w, 'descend');
vocabList = getVocabList();

fprintf('\nTop predictors of spam: \n');
for i = 1:15
    fprintf(' %-15s (%f) \n', vocabList{idx(i)}, weight(i));
end

fprintf('\n\n');
fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% ======================= Try Your Own Emails =========================
%  can try using it on your own emails
%  (included spamSample1.txt, spamSample2.txt, emailSample1.txt and emailSample2.txt 
%  as examples
%  The following code reads in one of these emails and then uses the
%  learned SVM classifier to determine whether the email is Spam or Not Spam

% Set the file to be read in (change this to spamSample2.txt,
% emailSample1.txt or emailSample2.txt to see different predictions on
% different emails types). Try your own emails as well!
filename = 'spamSample1.txt';

% Read and predict
file_contents = readFile(filename);
word_indices  = processEmail(file_contents);
x             = emailFeatures(word_indices);
p = svmPredict(model, x);

fprintf('\nProcessed %s\n\nSpam Classification: %d\n', filename, p);
fprintf('(1 indicates spam, 0 indicates not spam)\n\n');

