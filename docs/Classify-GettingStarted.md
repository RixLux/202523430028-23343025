## Getting started

Since this assignment need to use Teachable machine then that mean we are creating our own model

--- 

### Getting the model


1. First step is obviously getting the dataset, feel free to pick any theme e.g. fruit 
```
https://www.kaggle.com/datasets/moltean/fruits
```

[kaggle](https://www.kaggle.com/datasets/moltean/fruits)

> Get them from there or idk maybe get one yourself

2. Head to Google Teachable Machine to create .tflite model
```
https://teachablemachine.withgoogle.com/train/image
```
[Teachable Machine](https://teachablemachine.withgoogle.com/train/image)

3. Name each class properly and upload your data.  
![Step1](Images/Classify/Step1.png) 

4. Click train and just wait patiently
> mind you this would take a long time depend on your data.

5. Export model to tflite
![Step2](Images/Classify/Step2.png) 

6. Download the model
![Step3](Images/Classify/Step3.png)

7. Unpack the model on assets folder on the root of your flutter project
![Step7](Images/Classify/Step7.png)  

8. Add this to pubspec.yaml
```
  assets:
    - assets/model_unquant.tflite
    - assets/labels.txt
```  

mind you the indentation matter
```
flutter:
  uses-material-design: true

  assets:
    - assets/model_unquant.tflite
    - assets/labels.txt
```
