## CIS195 Final Project: Roommates

# Group Members
- Derick Olson
- Sam Lobel

# Code
Frontend: github.com/dericko/RoommatesApp
Backend: github.com/samlobel/RoOmMaTeS_V2

# Instructions
- please make sure to open RoommatesApp.workspace (not .proj) 
as we are using cocoapods
- Cocoapods should be included in project, but if not 
you can install using “$pod install” on the Podfile
- Project tested to run on iOS v.8.1
- There have been issues with the newest version of Xcode and the 
library/framework distinction, as we wrote our code in Obj C but
use a swift library for socket.io (the main source of our painful
technical difficulties the other day..) But things work great on
6.1.1

# Updates from Demo
- Server should be up and running on EC2
- 


# Features implemented
- User login/register from app (auth’d via passport.js)
- Search for friends and create groups
- Chat window for group members only (used socket.io)
- Used AFNetworking to send requests to node.js server
- Deployed server on AWS EC2
- Deployed database on mongolabs
- Venmo authentication


# Features not implemented
- Venmo payments/bill splitting
We didn’t have the time to get a payments
workflow going, but instead load a simple
page that displays the authenticated user’s
venom name and current balance.
- A nice UI
With time constraints, we prioritized functionality
over looks. We do plan on working on this project
further and will focus on the look and feel of the
app on further iterations
- Multiple groups per user
We found that managing multiple groups would
complicate the app flow, without adding much 
to 