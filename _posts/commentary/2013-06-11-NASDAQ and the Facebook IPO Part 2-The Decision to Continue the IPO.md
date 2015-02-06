---
title: "NASDAQ and the Facebook IPO"
subtitle: "Saving the IPO"
layout: post
author: "Chris Clearfield and Steven Lofchie" 
tags: [complexity,technology,NASDAQ] 
permalink: 
---

![image alt text](/assets/images/NASDAQ and the Facebook IPO Part 2-The Decision to Continue the IPO_images/image_0.jpg)

*In[ Part One](http://www.system-logic.com/commentary/posts/NASDAQ%20and%20the%20Facebook%20IPO%3A%20The%20Race%20Condition1bKE) of my series on NASDAQ, I recapped the coding errors that led to the delay of the initial public market trading of Facebook, one of the most anticipated Initial Public Offerings (IPOs) in history. In this article, I examine the technical details of the fix NASDAQ implemented to save the launch of the IPO, and the subsequent consequences.* 

## The Fix

The Facebook IPO cross was initiated at 11:05 am, but did not complete as expected. Immediately after NASDAQ realized that the cross was delayed, its senior management convened a "Code Blue" call to discuss the situation. The reason for the delay was unknown at that time. 

As discussed [in the first article](http://www.system-logic.com/commentary/posts/NASDAQ%20and%20the%20Facebook%20IPO%3A%20The%20Race%20Condition1bKE) in the series, we now know the amount of activity surrounding the IPO triggered a race condition, which had lead the NASDAQ’s IPO software application that calculated the cross execution to become stuck in a loop as it tried to process a growing queue of cancels. After a few minutes, engineers at the exchange realized that the cross was not completing because the *validation check* was failing. The validation check was a safeguard which ensured that NASDAQ’s matching engine and the IPO cross application had the same set of orders and cancels.

The validation check *correctly* indicated that there had been a loss of integrity between the matching engine and the IPO cross. However, NASDAQ engineers tried to override the check to force the completion of the IPO cross. First, they attempted to issue commands to direct the IPO cross to ignore the validation check. When this effort failed, the engineers came up with a plan: they would amend the matching engine’s code to ignore the validation check, deploy the amended matching engine on its backup server ( The backup server formed part the redundancy NASDAQ maintained in case of problems with its primary production stack, and was generally not used to deploy untested changes. ), then switch from NASDAQ’s production server to its backup server, thus running the now-modified backup server to complete the cross and save the launch of the IPO. 

This solution would remove the protection afforded by the validation check and cause the IPO cross to execute, but without processing the orders that had been cancelled during the IPO calculation itself. In internal discussions, NASDAQ management anticipated this side effect, but reasoned that because the cross calculation time is quite short (a few milliseconds), there would be very few such cancelled orders.  On this assumption (which turned out to be mistaken), NASDAQ made a business decision: it would "step into" any improperly matched transactions and take the filled shares from the orders that were intended to be cancelled, effectively taking a position in NASDAQ’s proprietary error account. 

While a later piece in this series will address the biases that can occur during dynamic and stressful situations, it is worth noting that the attempt to continue the cross involved disabling the validation check, a safeguard that had been deliberately built into the IPO match process. By working around the safeguard so as to force the IPO cross to occur, NASDAQ engineers were working on the fly, without testing, and without knowing why the problem had occurred in the first place. 

## The Fallout

The IPO cross did execute on the backup server after the validation code was removed and the plan to switch to the backup server was implemented. But the NASDAQ stock exchange is complicated, and bypassing the validation check caused a series of unexpected consequences that spread to other parts of NASDAQ’s system. 

*There were more unaccounted orders than expected.* The first unexpected consequence was that, rather than a few milliseconds of cancels that had not yet been processed, there were almost *nineteen minutes* of both cancels and new orders unprocessed because the IPO cross had been stuck in a loop. Due to the large number of cancels, NASDAQ assumed a much larger error position than they originally expected. Additionally, approximately 38,000 cross-eligible orders were unexpectedly ignored and not executed in the cross. This failure violated NASDAQ’s own rules governing the prioritization of orders ( Price/time priority specifies that orders with more aggressive prices (higher prices for purchases and lower prices for sales) should be executed before less aggressive orders (price priority). For equally aggressive orders, the order entered first should execute first (time priority). ). 

*Other trading on the exchange was disrupted.* The IPO cross engine is used for both initial public offerings and for the orderly resumption of trading in halted securities ( For example, a security may halt for news dissemination or after a large move in a security. ). When shares of the company Zynga halted at 11:37 after moving more than 10% in the previous five minutes, the security entered into the IPO cross engine in order to resume trading after a five minute "cooling-off" period. However, the IPO engine was still delayed from its loop processing Facebook cancels, and as a result, the resumption of Zynga shares was disrupted. 

*Confirmations from the IPO cross were delayed.* NASDAQ did not deliver confirmations for orders executed in the IPO cross. In the absence of confirmations, NASDAQ member firms that had sent orders could not tell if those orders eligible for the cross had been executed, information critical to serving their customers and managing their proprietary risk. The NASDAQ component that delivered confirmations contained a check that verified that the shares executed by the IPO cross matched the total eligible shares. In this case, those quantities did not match, because of the unintended loop in the IPO cross and the delay in processing cancels. As a result, the confirmations were not disseminated, and the cross itself was marked as "in error," which also halted the distribution of market data.

It took over two hours for NASDAQ to resolve the problem and send confirmations from the cross. During this time, not only did NASDAQ member firms participating in the cross not receive their confirmations, NASDAQ itself did not get a handle on the proprietary risk that it had accumulated by taking on an error position. Rather than a small position caused by a few cancels, NASDAQ had assumed $129 million dollars in short exposure to Facebook’s stock. Because Facebook’s price declined subsequent to the IPO, NASDAQ profited by over ten million dollars when it bought the shares back to close its error position. 

## Conclusion

Continuing the IPO without understanding the underlying causes of the delay put the NASDAQ stock exchange in uncharted territory. Complex technology systems, like an exchange, are tightly integrated and operate only when components interact in expected, planned ways. Disrupting the interaction between the IPO cross and the validation check by making on-the-fly code changes led to a cascade of failures, where an error in one part of the system unexpectedly affected many other components. Once the election was made to force the completion of the IPO cross, a series of additional failures was inevitable, even as the specifics of those failures were impossible to predict before they happened.

*[Chris Clearfield](http://www.system-logic.com/team/) is a principal at [System Logic](http://www.system-logic.com), an independent consulting firm that helps organizations manage issues of risk and complexity.* 

## Lofchie Commentary

I take the lesson of this to be: if something goes wrong with a complicated system, put the planned activity on hold until the problem can be identified and the solution can be tested. Psychologically, this is a disappointing lesson: it says, "don’t improvise under pressure." Not exactly the climactic ending of a great Hollywood movie. 

From a legal, compliance, and risk management (not to mention psychological) standpoint, if that is the lesson, it does raise some interesting challenges. First off, how does management know what is a "real" problem that can not be fixed on the fly and what is a minor problem that is easily remedied; e.g., I forgot to plug in the cord. Second, in the case of serious problems, procedures manuals may need to include instructions to “give up,” not to attempt dramatic solutions to unexpected problems, but rather to fight another day. Thirdly, it raises the question of what is the “backup plan” in situations where the backup plan is not: fix it with last second ingenuity, but rather, go home and sleep on it. 

[Steven Lofchie](http://www.cadwalader.com/Attorney/Steven_D._Lofchie/1318) is the co-head of the Financial Services Department at [Cadwalader, Wickersham & Taft](http://www.cadwalader.com/thecabinet/)[.](http://www.google.com/url?q=http%3A%2F%2Fwww.cadwalader.com%2Fthecabinet%2F&sa=D&sntz=1&usg=AFQjCNHSL31r3iN_Oj9skKtZ4CSZy_3tSg)

