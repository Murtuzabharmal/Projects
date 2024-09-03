Diabetes Prediction using Naive Bayes

Overview
This project involves predicting the likelihood of diabetes in patients using the Naive Bayes classifier, a simple yet effective machine learning model. The project utilizes the Pima Indians Diabetes Database, a popular dataset used for machine learning in the medical field. By analyzing and pre-processing the data, we aim to build a predictive model that achieves a good balance between accuracy and simplicity.

Dataset
The dataset used in this project is the Pima Indians Diabetes Database, available on Kaggle. It contains several physiological variables (features) that may influence diabetes outcomes. 

The dataset includes the following features:

•	Pregnancies: Number of times pregnant

•	Glucose: Plasma glucose concentration after 2 hours in an oral glucose tolerance test

•	BloodPressure: Diastolic blood pressure (mm Hg)

•	SkinThickness: Triceps skinfold thickness (mm)

•	Insulin: 2-Hour serum insulin (mu U/ml)

•	BMI: Body mass index (weight in kg/(height in m)^2)

•	DiabetesPedigreeFunction: Diabetes pedigree function (a function which scores likelihood of diabetes based on family history)

•	Age: Age in years

Outcome: Class variable (0 or 1) where 1 indicates the presence of diabetes

Data Preprocessing

Data preprocessing is a crucial step in any machine learning project. The following steps were taken to preprocess the data:

Handling Missing Values: The dataset had some missing or zero values in features such as Glucose, BloodPressure, SkinThickness, Insulin, and BMI. These were either imputed using the median or removed.

Splitting the Data: The dataset was split into training (80%) and testing (20%) sets using train_test_split from sklearn.model_selection.

Feature Scaling: Features were scaled using StandardScaler to standardize the range of the feature values. This is important for models like Naive Bayes to ensure that all features contribute equally to the model.

To enhance the performance of the model, feature selection was performed using the following methods:

SelectKBest (Chi-Square Test): This method selects the top k features based on the chi-squared statistic. It is effective for categorical data but requires non-negative features.

Variance Threshold: This technique removes all features with variance below a certain threshold. Features with low variance typically have little impact on the mode


Modelling
The Naive Bayes classifier was chosen for this project due to its simplicity and efficiency, particularly with small datasets and when the assumption of feature independence is reasonable.

The model was evaluated using several metrics:

Confusion Matrix: The confusion matrix shows the number of true positives, true negatives, false positives, and false negatives.

Accuracy: The Naive Bayes model achieved an accuracy of approximately 89%.

The confusion matrix showed a balanced performance between true positive and true negative predictions, with a moderate number of false positives and negatives.


Conclusion
The Naive Bayes classifier demonstrated good performance in predicting diabetes with an accuracy of 89%. While the model is simple and fast, further improvements could be made by exploring other machine learning models or by further optimizing the feature selection and data preprocessing steps.


Installation
To run this project, ensure you have Python installed along with the necessary libraries listed in requirements.txt. You can install them using pip:

Command: pip install -r requirements.txt

Clone the repository: git clone https://github.com/yourusername/Diabetes-Prediction-using-Naive-Bayes.git

Navigate to the project directory: cd Diabetes-Prediction-using-Naive-Bayes

Run the Jupyter Notebook or execute the scripts in the src directory to preprocess the data, train the model, and evaluate its performance.


collab link - https://colab.research.google.com/drive/1y8ziB0S2j5tN4kMMGBNrkLJhKTr72pSK?usp=sharing




