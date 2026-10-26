# signup_app

A new Flutter project that demonstrates the signup screen.

Name: Seul An Kim

Q1. Trace the local tip feature from button tap to displayed text. Which widget/state changes during the simulated loading state, and how does the user recover from the local error case?

A1. When the user taps the "Local AI Demo Tips" button, the _getSignupTip() function is called. First, setState() changes _tipMessage to an empty string, temporarily hiding the previous tip from the screen. The app then simulates a one-second loading delay using Future.delayed(). After the delay, the function retrieves a preset tip from _localTips using the fixed _tipCategory and selects it using _tipIndex. Another setState() updates _tipMessage, causing the Text widget to display the selected tip. If the local tips are unavailable, the else block calls setState() without displaying an error message. The user can tap the tip button again to recover from the error state.

Q2. Why must the app keep form validation local even when it can ask an AI for a tip? Give one example of a bad decision if AI were allowed to approve signup.

A2. We need to keep the signup information local and private, and make sure they are not released to the open internet. If I allow the AI agent to approve the signup, AI agent will be able to get the users' signup information and if this information is released, everyone's information would be vulnerable. Also, AI-generated suggestions may be inaccurate or inconsistent due to unpredictable bug. For example, if AI were allowed to approve signup, it might incorrectly accept a password containing fewer than six characters because it considers the password acceptable. Therefore, AI tips should only provide helpful suggestions, without being able to access the users' actual signup information.