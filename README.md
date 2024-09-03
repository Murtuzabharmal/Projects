# Diabetes-Prediction-ussing-Naive-Bayes-
Diabetes Prediction using Naive Bayes
Overview
This project involves predicting the likelihood of diabetes in patients using the Naive Bayes classifier, a simple yet effective machine learning model. The project utilizes the Pima Indians Diabetes Database, a popular dataset used for machine learning in the medical field. By analyzing and pre-processing the data, we aim to build a predictive model that achieves a good balance between accuracy and simplicity.

Table of Contents
Project Structure
Dataset
Data Preprocessing
Feature Selection
Modeling
Model Evaluation
Results
Conclusion
Installation
Usage
Acknowledgments
Project Structure
bash
Copy code
Diabetes-Prediction-using-Naive-Bayes/
├── data/
│   ├── diabetes.csv           # Dataset used for training and testing
├── notebooks/
│   ├── Diabetes_Prediction.ipynb  # Jupyter Notebook with full analysis
├── src/
│   ├── data_preprocessing.py  # Script for data preprocessing
│   ├── feature_selection.py   # Script for feature selection
│   ├── model_training.py      # Script for model training and evaluation
├── README.md                  # Project overview and setup instructions
└── requirements.txt           # Required Python libraries
Dataset
The dataset used in this project is the Pima Indians Diabetes Database, available on Kaggle. It contains several physiological variables (features) that may influence diabetes outcomes. The dataset includes the following features:

Pregnancies: Number of times pregnant
Glucose: Plasma glucose concentration after 2 hours in an oral glucose tolerance test
BloodPressure: Diastolic blood pressure (mm Hg)
SkinThickness: Triceps skinfold thickness (mm)
Insulin: 2-Hour serum insulin (mu U/ml)
BMI: Body mass index (weight in kg/(height in m)^2)
DiabetesPedigreeFunction: Diabetes pedigree function (a function which scores likelihood of diabetes based on family history)
Age: Age in years
Outcome: Class variable (0 or 1) where 1 indicates the presence of diabetes
Data Preprocessing
Data preprocessing is a crucial step in any machine learning project. The following steps were taken to preprocess the data:

Handling Missing Values: The dataset had some missing or zero values in features such as Glucose, BloodPressure, SkinThickness, Insulin, and BMI. These were either imputed using the median or removed.

Splitting the Data: The dataset was split into training (80%) and testing (20%) sets using train_test_split from sklearn.model_selection.

Feature Scaling: Features were scaled using StandardScaler to standardize the range of the feature values. This is important for models like Naive Bayes to ensure that all features contribute equally to the model.

python
Copy code
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)
Feature Selection
To enhance the performance of the model, feature selection was performed using the following methods:

SelectKBest (Chi-Square Test): This method selects the top k features based on the chi-squared statistic. It is effective for categorical data but requires non-negative features.

Variance Threshold: This technique removes all features with variance below a certain threshold. Features with low variance typically have little impact on the model.

python
Copy code
selector = VarianceThreshold(threshold=(.8 * (1 - .8)))
X_train_selected = selector.fit_transform(X_train)
X_test_selected = selector.transform(X_test)
Modeling
The Naive Bayes classifier was chosen for this project due to its simplicity and efficiency, particularly with small datasets and when the assumption of feature independence is reasonable.

python
Copy code
model = GaussianNB()
model.fit(X_train_selected, y_train)
y_pred = model.predict(X_test_selected)
Model Evaluation
The model was evaluated using several metrics:

Confusion Matrix: The confusion matrix shows the number of true positives, true negatives, false positives, and false negatives.
python
Copy code
cm = confusion_matrix(y_test, y_pred)
sns.heatmap(cm, annot=True, fmt="d", cmap="Blues")
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.show()
Accuracy Score: Accuracy is the ratio of correctly predicted instances to the total instances.
python
Copy code
accuracy = accuracy_score(y_test, y_pred)
print(f'Accuracy: {accuracy:.2f}')
F1 Score: The F1 score is the harmonic mean of precision and recall, providing a balanced measure of model performance.
python
Copy code
f1 = f1_score(y_test, y_pred)
print(f'F1 Score: {f1:.2f}')
Results
Accuracy: The Naive Bayes model achieved an accuracy of approximately 89%.
F1 Score: The F1 score was approximately [insert F1 score here].
The confusion matrix showed a balanced performance between true positive and true negative predictions, with a moderate number of false positives and negatives.
Conclusion
The Naive Bayes classifier demonstrated good performance in predicting diabetes with an accuracy of 89%. While the model is simple and fast, further improvements could be made by exploring other machine learning models or by further optimizing the feature selection and data preprocessing steps.

Installation
To run this project, ensure you have Python installed along with the necessary libraries listed in requirements.txt. You can install them using pip:

bash
Copy code
pip install -r requirements.txt
Usage
Clone the repository:
bash
Copy code
git clone https://github.com/yourusername/Diabetes-Prediction-using-Naive-Bayes.git
Navigate to the project directory:
bash
Copy code
cd Diabetes-Prediction-using-Naive-Bayes
Run the Jupyter Notebook or execute the scripts in the src directory to preprocess the data, train the model, and evaluate its performance.
Acknowledgments
Kaggle for providing the dataset.
Scikit-learn for the machine learning tools.
Matplotlib and Seaborn for data visualization.

collab link - https://colab.research.google.com/drive/1y8ziB0S2j5tN4kMMGBNrkLJhKTr72pSK?usp=sharing

# Online Fraud Detection
If you want to run this project, you must have a Kaggle account and an API key. The data used in this project was obtained from Kaggle. The required libraries will be automatically downloaded when you run the project. To obtain a Kaggle API key, you can follow the instructions provided by Christian Mills 1. Once you have obtained your API key, you can store it in a secure location on your computer. Please ensure that you do not share your API key with anyone or upload it to public repositories.

# Networking
To run this networking project, you will need to have GNS3 installed on your computer. The project involves configuring VLANs, OSPF, EIGRP, and a FortiGate firewall. To get started, you will need to import the project file into GNS3. Here are the steps to follow:

Open GNS3 and click on File in the top left corner of the window.
Select Import Appliance from the dropdown menu.
Navigate to the location where you have saved the project file and select it.
Click on Open to import the project file into GNS3.
Once you have imported the project file, you should be able to run the project in GNS3. If you have any issues with the project, please refer to the documentation provided with the project or seek help from the project creator.
