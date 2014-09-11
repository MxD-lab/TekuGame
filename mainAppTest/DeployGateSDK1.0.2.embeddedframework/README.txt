DeployGate iOS SDK version 1.0.
Copyright 2014 mixi, Inc. All rights reserved.

=========================================================
DESCRIPTION:

First note that you may use basic features of DeployGate without installing the SDK. Once you drop your current app package onto DeployGate, you may download it through DeployGate immediately, watch how installation is going on the dashboard and further app updates can also be pushed over the air.

Installing the DeployGate SDK into your project enables powerful features, such as crash reporting, remote Logging, update notification and user authentication.

Since installing the DeployGate SDK is fairly simple, just add the iOS SDK file, insert one line to your application and it's done. We highly recommend you to use it.

This SDK is packaged as a header file and static library. Get started by adding the DeployGateSDK-1.0.embeddedframework directory to your XCode project. You must SystemConfiguration.framework in your project.

You need a Author Name and API Key to use the SDK. It is provided on DeployGate Document (https://deploygate.com/docs/ios_sdk).

=========================================================
BUILD REQUIREMENTS:

Xcode with iOS SDK 6.0 or later the Apple LLVM compiler.

=========================================================
RUNTIME REQUIREMENTS:

iOS 6.0 or later.

Your app must link SystemConfiguration.framework

=========================================================
INTEGRATION:

1. Add the DeployGateSDK-1.0.embeddedframework directory to your project.
2. Verify that DeployGate.framework has been added to the Link Binary With libraries Build phase for the targets you want to use the SDK.
3. Add SystemConfiguration.framework to your Link Binary With Libraries Build Phase
4. Get Application Owner Name and API Key on https://deploygate.com/docs/ios_sdk after Login.
5. In your Application Delegate
  1. Import DeployGate: ‘#import <DeployGateSDK/DeployGateSDK.h>’
  2. Launch DeployGate with Owner Name and API Key in your ‘-application:didFinishlaunchingWithOption:’

            -(BOOL)application:(UIApplication *)application 
                didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
              // ...

              [[DeployGateSDK sharedInstance] launchApplicationWithAuthor:@“OWNER_NAME”
                                                                         key:@“API_KEY”];

              // ...
            }
	
6. Build your app and upload it to deploygate.com.

=========================================================
FEATURES:

* Update Notification
If users has permission to install the app, SDK shows AlertView and asks them  if they would like to install the update when launching. If they tap “Install”, SDK transit the install page on mobile safari.

* Crash Report
The SDK automatically reports crashes to deploygate.com where you can see them. Crash Report are sent at next launch time. DeployGate hasn’t symbolicate the crashes yet. 

* App Boot Reporting
The SDK reports who and when launch the app. You can see the reports on your application page.

* User Authorization
In some cases, you may want to restrict app distribution only to users you explicitly allowed. The SDK provide to check if users has permission for the app.

* Remote Log
The SDk allows you to see the logs your app  print out remotely on deploy gate.com. Remote Log are sent at next launch time. To use it, simply replace all of your ’NSLog’ calls with ‘DGSLog’ calls. An easy way to do this without rewriting all your ’NSLog‘ calls is to add the following macro to your ‘.pch’ file.

  #import <DeployGateSDK/DeployGateSDK.h>
  #define NSLog DGSLog

Note that you need to call DGSLog after the following methods.
- launchApplicationWithAuthor:key:
- launchApplicationWithAuthor:key:userInfomationEnabled:


=========================================================
PACKAGING LIST:

DeployGateSDK.framework/ (contains header file and binary file)
Resource/ (contains Resource files used in DeployGate iOS SDK)
  en.lproj
  ja.lproj
README.txt
CHANGELOG.txt
LICENSE.txt


