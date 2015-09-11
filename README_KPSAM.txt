**README for STATA CODE: KPSAM.do
**clear
**Authors: Khizar Qureshi, Nikhil Agarwal
The purpose of this file is to elucidate the functionality and syntax of KPSAM.do, the main file for KPSAM analysis.
Overview: The purpose of KPSAM.do is to tabulate and graph categorized patient behavior when offered a deceased donor kidney, both under pre-KAS and KAS rules. While it was first developed for a 2010 cohort of patients under standard rules, the file has been made robust to withstand (i) variation in rules (ii) variation in patient waiting lists (iiI) variation in match sequences, and so on. 
Procedure: To maintain formatting, the authors suggest manually importing .out files  into STATA (match, deaths, wait lists, etc.). This is primarily because these .out files are pipe-delimited. Next, we suggest changing your directory to the file containing KPSAM.do. Then, in the editor window, type "do KPSAM".
Variable Overview: The authors have tried to keep the script variables in line with the procedure and problem at hand. These variables are static strings, doubles, and booleans, and include patient characteristics, decision variables, acceptance variables, acceptance rates, and probabilities. Let's broadly define the most pertinent:
Decision: String for patient decision to accept/reject organ
Accept: Boolean for patient decision to accept organ
Mon3: Extracted list of months [1,12] that each offer/decision belongs to
Category2 {Pediatric, Adolescent, Adult, Middle, UpMiddle, Senior}: A class containing various age groups with respective boundaries {11, 18, 35, 50, 65} for acceptance
Category3 {high, highmid, lowmid, low}: A class containing various CPRA level groups with respective boundaries {99, 85, 35, 20} for acceptance
**Acceptances**
allaccept: The number of organ acceptances on a monthly basis
alloffer: The number of organ offers on a monthly basis
frac: The number of acceptances in the high age difference (>15 years) category
frachigh: The fraction of acceptances in the high CPRA category
Ti {17, 34, 49, 64}: The fraction of acceptances for each age group
bloodtypeaccept {A, AB, B, O}: A class containing various blood types for acceptance
Ti {A, AB, B, O}: The fraction of acceptances for each blood type. (pi = count)
CPRAi {0, 79, 94, 98, 100}: A category defining various CPRA levels
Ti {0, 79, 94, 98, 100}: The fraction of acceptances for each CPRA level
**Offers**
overofferfrac: The number of offers in the high age difference (>15 years) category
frachighoffer: The fraction of offersin the high CPRA category
Tioffer {17, 34, 49, 64}: The fraction of offers for each age group
bloodtypeoffer {A, AB, B, O}: A class containing various blood types foroffers
Tioffer {A, AB, B, O}: The fraction of offers for each blood type. (pi2 = count)
CPRAioffer {0, 79, 94, 98, 100}: A category defining various CPRA levels for offers
Tioffer {0, 79, 94, 98, 100}: The fraction of offers for each CPRA level
**Acceptance Rates**
ratei {A, AB, B, O, c0, c79, c94, c98, c100, 18, 35, 50, 65, inf}: Acceptance rates for categories (blood type, CPRA level, age group)
rateover: Acceptance rates for large age differences
ratecpra: Acceptance rates for high CPRA 
**Probability of Acceptance**
iprob {ped, ado, adult, middle, upmid, senior}: Probability of acceptance by age group
iprob {A, AB, B, O}: Probability of acceptance by blood type
CPRAiprob {0, 79, 94, 18, 100}: Probability of acceptance by CPRA boundary
overprob: Probability of acceptance by large age difference (>15)
highCPRAprob: Probability of acceptance for large CPRA
monprob: Probability of acceptance overall

Note: All of the above cateogies and variables are sorted on a month-by-month basis. 





