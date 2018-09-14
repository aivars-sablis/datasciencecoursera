Codebook
========


Variable list and descriptions in Tidy file
------------------------------

Variable name    | Description
-----------------|------------
subject          | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.
activity         | Activity name
f[feature]-mean()| Average value for each of the mean measurements for feature for each activity and each subject
f[feature]-std() | Average value for each of the std measurements for feature for each activity and each subject



Explanation of each file
----------------------------------
Variable name        | Description
---------------------|------------
`features.txt`       | Names of the 561 measurements for the features.
`activity_labels.txt`| Names and IDs for each of the 6 activities.
`X_train.txt`        | Training set.
`subject_train.txt`  | The ID of the volunteer related to each of the observations in `X_train.txt`.
`y_train.txt`        | The ID of the activity related to each of the observations in `X_train.txt`.
`X_test.txt`         | Test set.
`subject_test.txt`   | The ID of the volunteer related to each of the observations in `X_test.txt`.
`y_test.txt`         | The ID of the activity related to each of the observations in `X_test.txt`.


Dataset structure
-----------------

```r
str(data)
```

```
'data.frame':	10299 obs. of  66 variables:
 $ subject                           : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activity                          : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 5 5 5 5 5 5 5 5 5 5 ...
 $ tBodyAcc.mean...X                 : num  0.289 0.278 0.28 0.279 0.277 ...
 $ tBodyAcc.mean...Y                 : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 $ tBodyAcc.mean...Z                 : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
 $ tBodyAcc.std...X                  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
 $ tBodyAcc.correlation...X.Z        : num  0.4351 -0.0727 -0.1811 -0.3627 -0.1898 ...
 ...
```

Tidy Dataset structure
-----------------

```r
str(tidy)
```

```
'data.frame':	180 obs. of  66 variables:
 $ subject                           : int  1 1 1 1 1 1 2 2 2 2 ...
 $ activity                          : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 1 2 3 4 5 6 1 2 3 4 ...
 $ tBodyAcc.mean...X                 : num  0.277 0.255 0.289 0.261 0.279 ...
 $ tBodyAcc.mean...Y                 : num  -0.01738 -0.02395 -0.00992 -0.00131 -0.01614 ...
 $ tBodyAcc.mean...Z                 : num  -0.1111 -0.0973 -0.1076 -0.1045 -0.1106 ...
 $ tBodyAcc.std...X                  : num  -0.284 -0.355 0.03 -0.977 -0.996 ...
 $ tBodyAcc.correlation...X.Z        : num  -0.19123 -0.17701 -0.22554 -0.20119 -0.00543 ...
 $ tBodyAcc.correlation...Y.Z        : num  0.3802 0.1616 0.0757 0.1183 0.2883 ...
 $ tGravityAcc.mean...X              : num  0.935 0.893 0.932 0.832 0.943 ...
 ...
 ```