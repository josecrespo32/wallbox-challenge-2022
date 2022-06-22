
# How to install and run the challenge test Wallbox for QA 


    It is recommended to use a python env and Python3

### System Under Test (aka SUT) deployed is described in
    https://github.com/josecrespo32/wallbox-challenge-2022 

### Meaning of the folders in /Tests
    
According to the challenge 3 tasks are required, to solve them I have created 2 folders under the acceptance dir:
    
1) Test Plan -> Contains the Test separated in tests suites used to validate the SUT and the report of the tests executed  
   - Test Results.html
   - Test Results - integration.html
   - Test Results - e2e.html
   - Test Results - bugs.html

 
2) Integration -> Features validation for input and output of the API components
   - 01_UpAndRunning.feature 
   - 02_Auth.feature         
   - 03_Users.feature        
   - 04_Chargers.feature 


3) End2End -> Features validations for behaviour of the flows that a user can follow as a business case models
   - 01_ChargersUsage.feature


### Implementation and process followed during the challenge: 

  With the lack of priority from Product team I am going to focus on the behaviours that from the QA perspective are the most critics and needed for a common use of the API like creation/update of users and his/him data, valid autentications and assosiations/desasosiations to chargers.


1) The first approach to understand and familiarize with the SUT was to use POSTMAN and launch a set of exploratory testing to see the behaviour against valid flows and invalid ones.

    Test collection imported from the swagger file available at https://www.getpostman.com/collections/3e4752962bbcf700bad8
    
3) The strategy to Integration tests was to check that the basic requests against the API and the response were according to the behaviour described in the challenge doc
    
4) Based on the Integration tests and reusing most of the steps defined in the Integration phase to cover the scenarios where a realworld user can interact with the API the way it was intended and in other case to cover it properly. 


### Bugs detected

 Bugs detected:
    
    - Swagger import file cannot be used prperly to test the lack of auth method implemented 
    - Add a new user require more params than the documentation shows, to continue with the tests I have assume that is a bug with the doc more than with the API but it should be fixed
    - Add a user that is already registered returns a 400 response when docs says 409 
    - Deleting a user that is linked to a charger should remove the link from the chargers where is linked currently is not doing it 
    - Models are not documented, so the source code was inspected to see the possibilites of them


### Future improvements

There are plenty of possible updates and improvements but with more time I will focus on improve and refactor the steps.py file. Reusing more functions and splitting it in different files.
The other priority will be to extract the data tests from a file or genereate it on the fly instead of using a fixed text input
Also the are much more scenarios to tests like error validations, token limitations (expired, logout) or users clean dbs and scenarios setups
I will fix the Postman error that generates an error of unexpected token when imported by default from swagger





    