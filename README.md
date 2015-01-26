# GettingAndCleaningDataProject

#Setup
The setup phase of the analysis simply loads the plyr and dplyr libraries, sets the working directory and downloads the data to it, and enters into the data folder

#Combine Training and Test Data
The first part of the project says to combine the training and test data. I did this by reading in the y,x and subject training and test files and then combining the y's together, x's together and subjects together using the rbind command

Once I did this I removed the training and test datasets to save memory

#Use only mean and standard Deviation measurements
The second step of the project says that we are only interested in the mean and standard deviation measurements.  In order to select only these measurements I read in the features.txt file and extracted the names of the features.  I then used the grep command to select the features that had standard deviation or mean in their names and combined the two sets together into a variable called keep, which I used to subset the data to only those features in which we were interested.

#Label Data Set With Descriptive Variable Names
I then skipped to the fourt step and gave all of the features the names from the features.txt file. These are fairly human-readable and replaced the V1,V2,V3 names automatically assigned.

In this step I also combined the SubjectNumber, Label Codes and renamed data into one table and removed the tables used in this construction.


#Give factor variables readable names
Now going back to step three I made the Subject Number and Label Codes factors, and replaced the numeric levels of the Label Codes factor with the associated activity names. I could have done this by reading in the codes from a file, but since there were only six of them I did it manually.

I also arranged the data so that it was ordered by Subject number. This was unnecessary but I think made it easier to look at.

#Take mean of each Variable for each activity and each subject 
For step five I just used the ddply command to take the mean of each column by Subject number and Label code making the final tidy dataset as requested.