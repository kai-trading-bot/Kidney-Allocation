**STATA CODE: KPSAM.do
**clear
**Authors: Khizar Qureshi, Nikhil Agarwal

** PART I */
*import delimited old2011match.out, delimeter("|") asdouble colrange(1:31) 
*tabulate candidatecpra, missing
*drop if missing(candidatecpra)
sort decision
by decision: summarize  donorage patientage candidatecpra  

** PART II **Initiation/
*import delimited old2011match.out, delim("|", collapse) asdouble colrange(1:31) 
generate event = eventtime
generate mon = substr(eventtime, 1, 2)
generate mon3 = mon
destring mon3, replace ignore(" ")

**age  group acceptances annual*/
**Defining the categories for each age group
gen accept = (decision == "Accepted")
gen pediatric = (patientage<11) & accept==1
gen adolescent = (patientage>=11 & patientage <18)& accept==1
gen adult = (patientage>=18 & patientage <35)& accept==1
gen middle = (patientage >=35 & patientage<50)& accept==1
gen upmiddle = (patientage>=50 & patientage<65)&accept==1
gen senior = (patientage>=65)& accept==1


**age group acceptances per month */
**Defining the class of age groups
gen category2 = "pediatric" if patientage < 11 & accept==1
replace category2 = "adolescent" if patientage>=11 & patientage<18 & accept==1
replace category2 = "adult" if patientage>=18 & patientage<35 & accept==1
replace category2= "middle" if patientage>=35 & patientage<50 & accept==1
replace category2 = "upmiddle" if patientage>=50 & patientage<65 & accept==1
replace category2 = "senior" if patientage>=65 &accept==1
tabulate category2 mon3

sort mon3
graph bar (sum) accept, over(mon3) by(category2)
*sort category2 mon3
*collapse (count) accept, by (category2 mon3)
*by category2: plot accept mon3

** PART III */
** Defining the class of CPRA levels
destring candidatecpra, replace ignore(" ")
gen category3 = "high" if candidatecpra>=99 & accept==1
replace category3 ="highmid" if candidatecpra>=85 & candidatecpra<99 & accept==1
replace category3 ="lowmid" if candidatecpra>=20 & candidatecpra<35 & accept==1
replace category3 ="low" if candidatecpra<20 & accept==1
sort mon3
graph bar (sum) accept, over(mon3) by(category3)

tabulate category3 mon3

** PART IV */
** Defining the category for donor/patient age differences>15
gen cutoff = 15
gen diff = abs(donorage-patientage)
gen over2 = diff>cutoff & accept==1
egen allaccept = sum(accept), by(mon3)
egen alloffer = sum(iter), by(mon3)
egen monsumover = sum(over2), by(mon3)
gen frac = monsumover/allaccept
sort mon3
graph twoway line frac mon3

** PART V */
** Defining the category for high CPRA candidates 
gen bound = 99
gen highcpra = candidatecpra >=bound & accept==1
*egen allaccept = sum(accept), by(mon3)
egen monsumcpra = sum(highcpra), by(mon3)
gen frachigh = monsumcpra/allaccept
sort mon3
graph twoway line frachigh mon3

** PART VI */
** Defining a counter for each age group 
sort mon3
by mon3: egen p11 = sum(pediatric)
sort mon3
by mon3: egen p17 = sum(adolescent)
gen p18 = p11 + p17
 sort mon3
by mon3: egen p35 = sum(adult)
sort mon3
by mon3: egen p50 = sum(middle)
sort mon3
by mon3: egen p65 = sum(upmiddle)
sort mon3
by mon3: egen pinf = sum(senior)
gen T17 =  p18/allaccept
gen T34 =  p35/allaccept
gen T49 =  p50/allaccept
gen T64 =  p65/allaccept
gen Tinf =  pinf/allaccept


** PART VII*/
** Defining the cateogies for each blood type
drop if missing(patientabo)
generate abo = patientabo
destring abo, replace ignore(" ")
gen A = (patientabo =="A") & accept==1
gen AB= (patientabo =="AB")& accept==1
gen B= (patientabo =="B")& accept==1
gen O= (patientabo =="O")& accept==1
gen bloodtypeaccept = "A" if abo=="A"& accept==1
replace bloodtypeaccept = "AB" if abo == "AB" & accept==1
replace bloodtypeaccept = "B" if abo =="B" & accept==1
replace bloodtypeaccept = "O" if abo == "O" & accept==1
sort mon3
by mon3: egen pA = sum(A)
sort mon3
by mon3: egen pAB = sum(AB)
sort mon3
by mon3: egen pB = sum(B)
sort mon3
by mon3: egen pO = sum(O)
** Fractionated blood-type categories
gen TA =  pA/allaccept
gen TAB =  pAB/allaccept
gen TB =  pB/allaccept
gen TO =  pO/allaccept
sort mon3
graph twoway line TA TAB TB TO mon3

**PART VIII */
** Defining the cateogies for each CPRA conditional on acceptance
gen CPRA0= (candidatecpra<1) & accept==1
gen CPRA79 = (candidatecpra>=1 &candidatecpra<80)& accept==1
gen CPRA94 = (candidatecpra>=80 &candidatecpra<95)& accept==1
gen CPRA98 = (candidatecpra>=95 &candidatecpra<=98)& accept==1
gen CPRA100= (candidatecpra>=99)& accept==1
sort mon3
by mon3: egen c0 = sum(CPRA0)
sort mon3
by mon3: egen c79 = sum(CPRA79)
 sort mon3
by mon3: egen c94 = sum(CPRA94)
sort mon3
by mon3: egen c98 = sum(CPRA98)
sort mon3
by mon3: egen c100 = sum(CPRA100)
** Fractionated CPRA categories
gen T0 =  c0/allaccept
gen T79 =  c79/allaccept
gen T94 =  c94/allaccept
gen T98 =  c98/allaccept
gen T100 =  c100/allaccept

sort mon3
graph twoway line T0 T79 T94 T98 T100 mon3
** PART IX */
tabstat TA TAB TB TO T0 T79 T94 T98 T100 T17 T34 T49 T64 Tinf frac frachigh, by(mon3)

**PART X */
** Defining offers by age group
gen ageoffer= "pediatric" if patientage < 11
replace ageoffer= "adolescent" if patientage>=11 & patientage<18
replace ageoffer= "adult" if patientage>=18 & patientage<35 
replace ageoffer= "middle" if patientage>=35 & patientage<50 
replace ageoffer= "upmiddle" if patientage>=50 & patientage<65 
replace ageoffer = "senior" if patientage>=65 
tabulate accept ageoffer


gen pediatricoffers = (patientage<11) 
gen adolescentoffers = (patientage>=11 & patientage <18)
gen adultoffers = (patientage>=18 & patientage <35)
gen middleoffers = (patientage >=35 & patientage<50)
gen upmiddleoffers = (patientage>=50 & patientage<65)
gen senioroffers = (patientage>=65)

sort mon3
by mon3: egen p11offer = sum(pediatricoffers)
sort mon3
by mon3: egen p17offer = sum(adolescentoffers)
gen p18offer = p11offer + p17offer
 sort mon3
by mon3: egen p35offer = sum(adultoffers)
sort mon3
by mon3: egen p50offer = sum(middleoffers)
sort mon3
by mon3: egen p65offer = sum(upmiddleoffers)
sort mon3
by mon3: egen pinfoffer = sum(senioroffers)
** Fractionating offers by age group
gen T17offer =  p18offer/alloffer
gen T34offer =  p35offer/alloffer
gen T49offer =  p50offer/alloffer
gen T64offer =  p65offer/alloffer
gen Tinfoffer =  pinfoffer/alloffer

** Defining offers by blood type

gen A2 = (patientabo =="A")
gen AB2= (patientabo =="AB")
gen B2= (patientabo =="B")
gen O2= (patientabo =="O")

** Defining a class for offers by blood type
gen  bloodtypeoffer= "A" if abo=="A"
replace bloodtypeoffer= "AB" if abo == "AB" 
replace bloodtypeoffer= "B" if abo =="B" 
replace bloodtypeoffer= "O" if abo == "O" 
tabulate accept bloodtypeoffer

sort mon3
by mon3: egen pA2 = sum(A2)
sort mon3
by mon3: egen pAB2 = sum(AB2)
sort mon3
by mon3: egen pB2 = sum(B2)
sort mon3
by mon3: egen pO2 = sum(O2)

** Fractionating offers by blood type
gen TA2 =  pA2/alloffer
gen TAB2 =  pAB2/alloffer
gen TB2 =  pB2/alloffer
gen TO2 =  pO2/alloffer

** Defining a class for offers by CPRA level

gen CPRAoffer= "0" if (candidatecpra<1) 
replace  CPRAoffer = "1-79" if (candidatecpra>=1 &candidatecpra<80)
replace  CPRAoffer = "80-94" if (candidatecpra>=80 &candidatecpra<95)
replace  CPRAoffer= "95-98" if (candidatecpra>=95 &candidatecpra<=98)
replace  CPRAoffer= "99+" if (candidatecpra>=99)
tabulate accept CPRAoffer

** Defining cateogies for offers by CPRA level

gen CPRA0offer= (candidatecpra<1) 
gen CPRA79offer = (candidatecpra>=1 &candidatecpra<80)
gen CPRA94offer = (candidatecpra>=80 &candidatecpra<95)
gen CPRA98offer = (candidatecpra>=95 &candidatecpra<=98)
gen CPRA100offer= (candidatecpra>=99)
sort mon3
by mon3: egen c0offer = sum(CPRA0offer)
sort mon3
by mon3: egen c79offer = sum(CPRA79offer)
 sort mon3
by mon3: egen c94offer = sum(CPRA94offer)
sort mon3
by mon3: egen c98offer = sum(CPRA98offer)
sort mon3
by mon3: egen c100offer = sum(CPRA100offer)

** Fractionating offers by CPRA level

gen T0offer =  c0offer/alloffer
gen T79offer =  c79offer/alloffer
gen T94offer =  c94offer/alloffer
gen T98offer =  c98offer/alloffer
gen T100offer =  c100offer/alloffer

gen highCPRAoffer = candidatecpra >= bound
sort mon3
by mon3: egen monsumcpraoffer = sum(highCPRAoffer)
gen frachighoffer = monsumcpraoffer/alloffer

gen overoffer = diff>cutoff
sort mon3
by mon3: egen monsumoveroffer = sum(overoffer)
gen overofferfrac = monsumoveroffer/alloffer

*acceptances by %
tabstat TA TAB TB TO T0 T79 T94 T98 T100 T17 T34 T49 T64 Tinf frac frachigh, by(mon3)
*acceptances by #
tabstat pA pAB pB pO c0 c79 c94 c98 c100 p18 p35 p50 p65 pinf monsumover monsumcpra, by(mon3)
*offers by #
tabstat pA2 pAB2 pB2 pO2 c0offer c79offer c94offer c98offer c100offer p18offer p35offer p50offer p65offer pinfoffer monsumcpraoffer monsumoveroffer, by(mon3) 
*offers by %
tabstat TA2 TAB2 TB2 TO2 T0offer T79offer T94offer T98offer T100offer T17offer T34offer T49offer T64offer Tinfoffer frachighoffer overofferfrac, by(mon3)


** part XI */

** Fractionating acceptance rates by blood type

gen rateA = pA/pA2
gen rateAB = pAB/pA2
gen rateB = pB/pB2
gen rateO = pO/pO2

** Fractionating acceptance rates by CPRA level

gen ratec0 = c0/c0offer
gen ratec79 = c79/c79offer
gen ratec94 = c94/c94offer
gen ratec98 = c98/c98offer
gen ratec100 = c100/c100offer

** Fractionating acceptance rates by age group

gen rate18 = p18/p18offer
gen rate35 = p35/p35offer
gen rate50 = p50/p50offer
gen rate65 = p65/p65offer
gen rateinf = pinf/pinfoffer

** Fractionating acceptance rates by donor/patient age difference>15

gen rateover = monsumover/monsumoveroffer

** Fractionating acceptance rates by high CPRA levels

gen ratecpra = monsumcpra/monsumcpraoffer


tabstat rateA rateAB rateB rateO ratec0 ratec79 ratec94 ratec98 ratec100 rate18 rate35 rate50 rate65 rateinf rateover ratecpra, by(mon3)

** part XII */

** Defining probability of acceptance by age group

gen pedprob = sum(probaccept) if pediatricoffers
gen sumped = sum(pediatricoffers)
sort mon3
by mon3: gen monpedprob = pedprob/sumped
tabstat monpedprob, by(mon3)

gen adoprob = sum(probaccept) if adolescentoffers
gen sumado=sum(adolescentoffers)
sort mon3
by mon3: gen monadoprob = adoprob/sumado
*tabstat monadoprob, by(mon3)

gen adultprob = sum(probaccept) if adultoffers
gen sumadult=sum(adultoffers)
sort mon3
by mon3: gen monadultprob = adultprob/sumadult
*tabstat monadultprob, by(mon3)

gen middleprob = sum(probaccept) if middleoffers
gen summiddle=sum(middleoffers)
sort mon3
by mon3: gen monmiddleprob = middleprob/summiddle
*tabstat monmiddleprob, by(mon3)

gen upmidprob = sum(probaccept) if upmiddleoffers
gen sumupmid=sum(upmiddleoffers)
sort mon3
by mon3: gen monupmidprob = upmidprob/sumupmid
*tabstat monupmidprob, by(mon3)

gen seniorprob = sum(probaccept) if senioroffers
gen sumsenior=sum(senioroffers)
sort mon3
by mon3: gen monseniorprob = seniorprob/sumsenior
*tabstat monseniorprob, by(mon3)

** Defining probability of acceptance by blood type

gen Aprob = sum(probaccept) if A2
gen sumA = sum(A2)
sort mon3
by mon3: gen monAprob = Aprob/sumA

gen ABprob = sum(probaccept) if AB2
gen sumAB = sum(AB2)
sort mon3:
by mon3: gen monABprob = ABprob/sumAB

gen Bprob = sum(probaccept) if B2
gen sumB = sum(B2)
sort mon3:
by mon3: gen monBprob = Bprob/sumB

gen Oprob = sum(probaccept) if O2
gen sumO = sum(O2)
sort mon3:
by mon3: gen monOprob = Oprob/sumO

** Defining probability of acceptance by CPRA level

gen CPRA0prob = sum(probaccept) if CPRA0offer
gen sum0cpra = sum(CPRA0offer)
sort mon3
by mon3: gen moncpra0prob = CPRA0prob/sum0cpra

gen CPRA79prob = sum(probaccept) if CPRA79offer
gen sum79cpra = sum(CPRA79offer)
sort mon3
by mon3: gen moncpra79prob = CPRA79prob/sum79cpra

gen CPRA94prob = sum(probaccept) if CPRA94offer
gen sum94cpra = sum(CPRA94offer)
sort mon3
by mon3: gen moncpra94prob = CPRA94prob/sum94cpra

gen CPRA98prob = sum(probaccept) if CPRA98offer
gen sum98cpra = sum(CPRA98offer)
sort mon3
by mon3: gen moncpra98prob = CPRA98prob/sum98cpra

gen CPRA100prob = sum(probaccept) if CPRA100offer
gen sum100cpra = sum(CPRA100offer)
sort mon3
by mon3: gen moncpra100prob = CPRA100prob/sum100cpra

** Defining probability of acceptance by donor/patient age difference>15

gen overprob = sum(probaccept) if overoffer
gen sumover = sum(overoffer)
sort mon3
by mon3: gen monoverprob = overprob/sumover

** Defining probability of acceptance by CPRA level

gen highCPRAprob = sum(probaccept) if highCPRAoffer
gen sumhigh = sum(highCPRAoffer)
sort mon3
by mon3: gen monhighprob = highCPRAprob/sumhigh

** Defining overall probability of acceptance

sort mon3
by mon3: egen monprob = mean(probaccept)
*tabstat monprob, by(mon3)

tabstat monpedprob monadoprob monadultprob monmiddleprob monupmidprob monseniorprob monAprob monABprob monBprob monOprob moncpra0prob moncpra79prob moncpra94prob moncpra98prob moncpra100prob monhighprob monoverprob monprob , by(mon3)












