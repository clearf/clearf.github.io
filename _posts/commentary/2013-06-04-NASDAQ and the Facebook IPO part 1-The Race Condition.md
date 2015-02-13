---
title: "NASDAQ and the Facebook IPO"
layout: post
author: "Chris Clearfield and Steven Lofchie" 
tags: [complexity,technology,NASDAQ] 
permalink: 
---

![image alt text](/assets/images/NASDAQ and the Facebook IPO part 1-The Race Condition_images/image_0.png)

On May 18th, 2012, the initial public market trade of Facebook, one of the most anticipated Initial Public Offerings (IPO) in history, was set to occur on the NASDAQ Stock Market. Unfortunately, the massive order flow from investors resulted in technical glitches that delayed the start of the IPO.  To avoid further delays, NASDAQ made a number of quick fixes that caused unexpected results and have subjected them to criticism from other market participants and, now, to a disciplinary action from the SEC.

On May 29th, the SEC issued findings and imposed a ten million dollar fine against NASDAQ for the consequences of technical failures and decision-making surrounding the IPO. [System Logic](http://www.system-logic.com) will undertake a series of articles that examine the technical details of the error, NASDAQ’s decision making, and the broader implications, from the standpoint of technology and processes around technology, of the SEC’s findings

Steven Lofchie, a partner at [Cadwalader](http://www.cadwalader.com/thecabinet/), will provide legal commentary on System Logic’s observations.   

## The Core Technical Issue

NASDAQ and the underwriters initially planned for the IPO to occur, and secondary market trading to begin, at 11:00am. After an underwriter-requested extension, NASDAQ initiated the IPO cross at 11:05.

After the IPO cross application determined the price and volume of the opening cross, NASDAQ’s matching engine performed a check to ensure that no cross-eligible orders had been cancelled during the calculation. This checking process typically requires about 2 milliseconds, but due to the volume of orders during the Facebook IPO, the cross and validation took around 20 milliseconds. The check found that cancellations had been received while the cross was being calculated. As a result, the price was recalculated incorporating those cancels. During the subsequent calculation and verification, two additional cancellations were received, necessitating another round of calculations. 

NASDAQ’s cross system was designed to process just the first cancellation in the queue. As a result, it had to run the calculation and validation again to process the next cancellation. Due to the high level of activity in the IPO, cancellations arrived faster than NASDAQ’s system could process them, sending the IPO cross and validation into an endless loop. As long as cancellations were arriving, the computer could not catch up. The IPO  cross was thus indefinitely delayed.

NASDAQ’s generally well-engineered system fell prey to what computer scientists refer to as a *race condition*, where the timing of different events influences their outcome. In this case, the timing of the arrival of cancels placed NASDAQ’s system into an unexpected state where it was unable to process all the cancels it was receiving.

Complex software systems that dynamically interact with external parties or processes are prone to such classes of errors, and their complexity also hinders their discovery. Though the characteristics and causes of this error are clear and understandable after the fact, NASDAQ’s system almost certainly contained this flaw, unmanifested, for years before the Facebook IPO. Only with the IPO’s massive volume did the conditions exist that triggered the problem. Perhaps NASDAQ could be faulted for not testing its IPO cross rigorously enough, but the SEC’s findings in the reported disciplinary action do not give us enough insight into their testing processes leading up to the event.

## The Decision To Continue...

Despite the technical glitch, the IPO cross occurred after a delay. In the next installment, we’ll catalog NASDAQ’s response after realizing there was a problem and the subsequent technical complications after the cross eventually occurred. 

***[Chris Clearfield](http://www.system-logic.com/team/)** is a principal at [System Logic](http://www.system-logic.com), an independent consulting firm that helps organizations manage issues of risk and complexity.* 

## Lofchie Commentary

From a legal standpoint, Mr. Clearfield’s description of the initial events raises a number of both regulatory policy and compliance process questions.

From a regulatory policy standpoint, the starting question is, is there anything in the above description that would call for a disciplinary action or is it more a matter of "s happens"?  One of the concerns that I have with our current regulatory and enforcement process is that there seems to be a need to bring an enforcement action in response to any material problem.  Businesses that make mistakes have to fix them; it does not necessarily follow, however, that the mistake was itself a violation of law, unless the law is defined to prohibit the making of mistakes.  

From the standpoint of compliance process, I note two difficulties in designing a "compliance" process that would have caught an error that Mr. Clearfield believes was embedded in the system for years.  As a starting matter, given that the crossing system had worked consistently over the time period, shouldn’t each successful operation of the system in actual practice be regarded as a successful “test,”  raising the question of what further testing would have been required.  Secondly, the knowledge that a further test of the NASDAQ system in advance of the IPO would have required, at a minimum, input from a number of different organizational lines that might not ordinarily interact: *i.e.,* the business people who might have anticipated that the Facebook volume would far exceed any prior experience and the technology professionals who might have anticipated that a massive increase in trading volumes would cause delays.  That said, in the ordinary course, it is not clear that these groups would interact and, even if they had, it is certainly not obvious to me that either could have or should have anticipated the issues.  So just how does a firm build a compliance process that can anticipate issues of the sort that arose in the Facebook IPO?   

[Steven Lofchie](http://www.cadwalader.com/Attorney/Steven_D._Lofchie/1318) is the co-head of the Financial Services Department at [Cadwalader, Wickersham & Taft.](http://www.cadwalader.com/thecabinet/)  

