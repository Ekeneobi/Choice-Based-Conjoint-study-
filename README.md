# Choice-Based-Conjoint-study-
Choice-Based Conjoint study in the Cloud Services Platform market using Multinomial Logit model

For this project I will run a Choice-Based Conjoint study in the Cloud Services Platform market (e.g. Amazon Web Services, Google Cloud, Microsoft Azure). The client wants to make some product design decisions such as core feature-sets, pricing, and tiers of service to optimise revenue or new sign-ups. I will work with the cloud.csv file. The file contains data on choices made by 200 respondents. Each respondent evaluated 15 choice sets. Thus, the file contains data on 200 × 15 = 3000 choice sets. Each choice set had three alternatives. A respondent’s task was to choose one alternative from a choice set. The following below describes the variables in the dataset:

Variable                      Description
respondent_id           Identifierfor each respondent (1 to 200)
choiseset_id            Identifier for each choice set for each respondent (1 to 15)
alternative_id          Identifier for each alternative in a choice set (1 to 3)
choice_id               Identifier for each choice set in the entire study (1 to 3000) 
cloud_storage           Attribute cloud storage with three levels: 30GB / 2000GB /5000GB
customer_support        Attribute customer support with two levels: Yes / No
cloud_services          Attribute cloud services with three levels: Email / Email + Video /Email + Video + Productivity
price                   Attribute price with three levels: £6 per month / £12 per month /£18 per month
choice                  Shows which alternative was chosen in each choice set (Dummy coded: 1 if alternative was chosen; 0 otherwise)
