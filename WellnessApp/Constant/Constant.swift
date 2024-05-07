//
//  Constant.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 03/09/21.
//

import Foundation
import UIKit

struct ConstantStoryboard {
    static let mainStoryboard               = UIStoryboard.init(name: "Main", bundle: nil)
    static let profileStoryboard            = UIStoryboard.init(name: "Profile", bundle: nil)
    static let gratitudeStoryboard          = UIStoryboard.init(name: "Gratitude", bundle: nil)
    static let meditationStoryboard         = UIStoryboard.init(name: "Meditation", bundle: nil)
    static let blogStoryboard               = UIStoryboard.init(name: "Blog", bundle: nil)
    static let breathExercisesStoryboard    = UIStoryboard.init(name: "BreathingExercise", bundle: nil)
    static let soothingMusicVideo           = UIStoryboard.init(name: "SoothingMusicVideo", bundle: nil)
    static let exerciseStoryboard           = UIStoryboard.init(name: "Exercise", bundle: nil)
    static let waterStoryboard              = UIStoryboard.init(name: "WaterIntake", bundle: nil)
    static let chakraLevelStoryboard        = UIStoryboard.init(name: "ChakraLevel", bundle: nil)
    static let heartRateStoryboard          = UIStoryboard.init(name: "HeartRate", bundle: nil)
    static let searchStoryboard             = UIStoryboard.init(name: "Search", bundle: nil)
    static let chatStoryboard               = UIStoryboard.init(name: "Chat", bundle: nil)
    static let pointsStoryboard             = UIStoryboard.init(name: "Points", bundle: nil)
    static let badgesStoryboard             = UIStoryboard.init(name: "Badges", bundle: nil)
    static let settingsStoryboard           = UIStoryboard.init(name: "Settings", bundle: nil)
    static let changePasswordStoryboard     = UIStoryboard.init(name: "ChangePassword", bundle: nil)
    static let aboutUsStoryboard            = UIStoryboard.init(name: "AboutUs", bundle: nil)
    static let termsStoryboard              = UIStoryboard.init(name: "TermsOfServices", bundle: nil)
    static let contactStoryboard            = UIStoryboard.init(name: "ContactUs", bundle: nil)
    static let faqStoryboard                = UIStoryboard.init(name: "FAQ", bundle: nil)
    static let favouriteStoryboard          = UIStoryboard.init(name: "Favourites", bundle: nil)
    static let notificationStoryboard       = UIStoryboard.init(name: "Notification", bundle: nil)
    static let moodStoryboard               = UIStoryboard.init(name: "Mood", bundle: nil)
    static let sleepStoryboard              = UIStoryboard.init(name: "Sleep", bundle: nil)
    static let videoPlay                    = UIStoryboard.init(name: "VideoPlay", bundle: nil)
    static let Coach                        = UIStoryboard.init(name: "coach", bundle: nil)
    static let CoachSideMenu                = UIStoryboard.init(name: "CoachSideViewController", bundle: nil)
    static let Meditation                   = UIStoryboard.init(name: "Meditation", bundle: nil)
    static let LiveSessionList              = UIStoryboard.init(name: "LiveSessionList", bundle: nil)
    static let RecordedSessionList          = UIStoryboard.init(name: "RecordedSessionList", bundle: nil)
    static let chatUser                     = UIStoryboard.init(name: "chatUser", bundle: nil)
    static let Call                         = UIStoryboard.init(name: "Call", bundle: nil)
    static let CoachRecoredeSessionlist     = UIStoryboard.init(name: "coachRecordedSessionList", bundle: nil)
    static let Payment                       = UIStoryboard.init(name: "Payment", bundle: nil)
   
    
    //static let Meditation
   
//CoachViewController
}

struct ConstantChakraID {
    static let rootChakra = "269702"
}
struct ConstantChakraName {
    static let rootChakra = "Root Chakra"
}

struct ConstantMeditationID {       //  "static medition Id:
    static let blockedChakras  = "849381"  //  ==> Meditation for blacked chakras
    static let guidedMeditation = "702340" ////  ==> Meditation for guided meditation
    static let manifestation   = "197740"//  ==> Meditation for Manifestation
    static let highPerformance = "840617"//  ==> Meditation for high performance"
}
struct ConstantMeditationStaticName {
    static let blocked          = "Blocked"
    static let guided           = "Guided"
    static let manifestation    = "Manifestation"
    static let performance      = "High Performance"
    
}
struct ConstantBreathExerciseID {       //  "Static breathing Exercise id
//    static let boxBreathing    = "535045"      //  ==> Box Breathing
    static let musicBreath     = "342723"      //  ==> Breathe with music
//    static let equalBreath     = "937914"      //  ==> Equal Breathing
    static let relaxBreath     = "968324"      //  ==> Relax Breathing"
}
//struct ConstantBreathExerciseName {       //  "Static breathing Exercise id
//    static let boxBreathing    = "Box Breathing"      //  ==> Box Breathing
//}


struct ConstantAlertTitle {
    static let LuvoAlertTitle           = "Luvo"
    static let ErrorAlertTitle          = "Error"
    static let OkAlertTitle             = "Ok"
    static let CancelAlertTitle         = "Cancel"
    static let SelectSourceAlertTitle   = "Select Source"
    static let CameraAlertTitle         = "Camera"
    static let PhotosAlertTitle         = "Photos"
}

struct ConstantAlertMessage {
    static let OTPMismatch              = "Entered OTP not matched"
    static let AcceptTerms              = "Accept terms & conditions"
    static let TryAgainLater            = "Try again later"
    static let ProfileUpdateSuccessful  = "Profile updated successfully"
    static let ProfileNoChanges         = "No changes to save"
    static let CameraUnavailable        = "This device has no camera hardware"
    static let ImageUploadSuccessful    = "Profile picture updated successfully"
    static let FromDateEmpty            = "Select from date"
    static let NoDataFound              = "No data found"
    static let EnterGratitude           = "Type in your gratitude for today"
    static let GratitudeBlank           = "Gratitude Not Found"
    static let UnlockMusic              = "You have successfully unlocked audio for next day"
    static let HeartRateDetectionMsg    = "Keep your index finger over the rear camera for your pulse detection"
    static let WaterIntakeAddMsg        = "You can only add water intake on current date"
}

struct ConstantStatusAPI {
    static let success  = "success"
    static let failed   = "Failed"
    static let timeout  = "Timeout"
}

struct ConstantInternetConnectionStatus {
    static let InternetOffline = "Internet connection is offline"
}

struct ConstantHttpMethod {
    static let POST     = "POST"
    static let PATCH    = "PATCH"
    static let PUT      = "PUT"
    static let GET      = "GET"
    static let DELETE   = "DELETE"
}

struct ConstantUploadImage {
    static let fileName         = "profilePic.jpg"
    static let parameterName    = "image"
}

struct ConstantUploadAudio {
    static let fileName         = "luvo.m4a"
    static let fileType         = "m4a"
    static let parameterName    = "music"
}

struct ConstantUploadSleep {
    static let fileName         = "sleepData.csv"
    static let fileType         = "csv"
    static let parameterName    = "sleep_data"
}

struct ConstantTextfieldAlertTitle {
    static let emptyNewPassword                 = "New password is empty"
    static let emptyConfirmPassword             = "Confirm password is empty"
    static let passwordConfirmPasswordNotSame   = "Password and confirm not same"
    static let userEmailIsEmpty                 = "User email is empty"
    static let userEmailInvalid                 = "User email is invalid"
    static let userPasswordIsEmpty              = "User password is empty"
    static let userNameIsEmpty                  = "User name is empty"
    static let userPhoneIsEmpty                 = "User phone number is empty"
    static let otp1stIsEmpty                    = "1st OTP field empty"
    static let otp2ndIsEmpty                    = "2nd OTP field empty"
    static let otp3rdIsEmpty                    = "3rd OTP field empty"
    static let otp4thIsEmpty                    = "4th OTP field empty"
    static let enterEmail                       = "Enter email id"
    static let resetTokenEmpty                  = "Reset token is empty"
    static let passwordEmpty                    = "Password is empty"
    static let firstNameEmpty                   = "First name is empty"
    static let lastNameEmpty                    = "Last name is empty"
    static let phoneValidation                  = "Phone number must be minimum 10 digit"
    static let gratitudeOtherEmpty              = "Enter your message for other"
    static let dailyGoalEmpty                   = "Enter your daily goal"
    static let dailyExerciseGoalZero            = "Your daily goal cannot be zero"
    static let dailyWaterGoalEmpty              = "Select your daily water intake goal"
    static let waterCupSizeEmpty                = "Enter your water cup size"
    static let msgEmpty                         = "Enter message to send"
    static let nameEmpty                        = "Enter your name"
    static let emailValid                       = "Enter valid email ID"
    static let oldPassEmpty                     = "Old password is empty"
    static let moodEmpty                        = "Select a mood"
}

struct ConstantSocialType {
    static let facebook     = "facebook"
    static let instagram    = "instagram"
    static let google       = "google"
    static let apple        = "apple"
}

struct ConstantDefaultImage {
    static let defaultImage = "/placeholder.png"
}

struct ConstantImageSet {
    static let placeholder  = "placeholder"
    static let showPassword = "eyeCross"
    static let hidePassword = "eye"
}

struct ConstantUserDefaultTag {
    static let udTempRememberMe             = "UD_TempRememberMe"
    static let udRememberMe                 = "UD_RememberMe"
    static let udToken                      = "UD_Token"
    static let udUserId                     = "UD_UserId"
    static let udUserName                   = "UD_UserName"
    static let udUserEmail                   = "UD_UserEmail"
    static let udUserDetails                = "UD_UserDetails"
    static let udSocialLoginBool            = "UD_SocialLoginBool"
    static let udQuestions                  = "UD_Questions"
    static let udPrevChakraLevel            = "UD_PrevChakraLevel"
    static let udPrevChakraName             = "UD_PrevChakraName"
    static let udBlockedChakraLevel         = "UD_BlockedChakraLevel"
    static let udBlockedChakraID            = "UD_BlockedChakraID"
    static let udBlockedChakraName          = "UD_BlockedChakraName"
    static let udDefaultExerciseID          = "UD_DefaultExerciseID"
    static let udDefaultExerciseName        = "UD_DefaultExerciseName"
    static let udDefaultRelaxBreathingID    = "UD_RelaxBreathingId"
    static let udDefaultMusicBreathingID    = "UD_MusicBreathingId"
    static let udFCMToken                   = "UD_FCMToken"
    static let udStepsCount                 = "UD_StepsCount"
    static let udNotificationBadge          = "UD_NotificationBadge"
    static let udSleepData                  = "UD_SleepData"
    static let udAppleSignInData            = "UD_AppleSignInData"
    static let udChakraColorchange          = "UD_ChakraColorChange"
    static let udChakraCrownListen          = "UD_ChakraCrownListen"
    static let udFromsideMenu               = "UD_Fromsidemenu"
    static let udFromTableviewSelected      = "UD_Tableviewselected"
    static let udFromBackGround             = "udFromBackGround"
    static let udFromCoachVC                = "UD_From_Coach_VC"
    static let udFromLive                   = "UD_FromLive"
}

struct ConstantActivityIndicatorMessage {
    static let pkLoading    = "Loading..."
    static let pkPleaseWait = "Please wait..."
}

struct ConstantQuestionBorderColor {
    static let row1 = "#B8DFBD"
    static let row2 = "#D6DEB9"
    static let row3 = "#D2C794"
    static let row4 = "#DECCB4"
    static let row5 = "#E3CECF"
}

struct ConstantBackgroundHexColor {
    static let offWhite = "FCFCFD"
}

struct ConstantBannerImage {
    static let banner1      = "question1"
    static let banner2      = "question2"
    static let banner3      = "question3"
    static let banner4      = "question4"
    static let banner5      = "question5"
    static let banner6      = "question6"
    static let banner7      = "question7"
    static let banner8      = "question8"
    static let banner9      = "question9"
    static let placeholder  = "question9"
}

struct ConstantSmileyImage {
    static let smiley1      = "rate5"
    static let smiley2      = "rate4"
    static let smiley3      = "rate3"
    static let smiley4      = "rate2"
    static let smiley5      = "rate1"
    static let placeholder  = "rate5"
}

//struct ConstantNavigationBarCornerRadius {
//    static let cornerRadius25: CGFloat = 25
//}

struct ConstantChakraColorTitle {
    static let redRootChakra        = "Red Color"
    static let orangeSacralChakra   = "Orange Color"
    static let yellowSolarChakra    = "Yellow Color"
    static let greenHeartChakra     = "Green Color"
    static let blueThroatChakra     = "Blue Color"
    static let violetThirdEyeChakra = "Violet Color"
    static let purpleCrownChakra    = "Purple Color"
}

struct ConstantChakraImageName {
    static let chakra0          = "chakra0"
    static let chakra1          = "chakra1"
    static let chakra2          = "chakra2"
    static let chakra3          = "chakra3"
    static let chakra4          = "chakra4"
    static let chakra5          = "chakra5"
    static let chakra6          = "chakra6"
    static let chakra7          = "chakra7"
    static let chakraAllOpen    = "chakraAllOpen"
}

struct ConstantChakraStatus {
    static let open     = "Open"
    static let blocked  = "Blocked"
}

struct ConstantAnimationDuration {
    static let duration: Double = 1.0
}
//
//struct ConstantFontName {
//    static let fontNunitoExtraBold = "Nunito-ExtraBold"
//}

struct ConstantNavgigationBarTitleText {
    static let titleChakraLevel = "Chakra Level"
}

//struct ConstantNavigationBarImageName {
//    static let imageLeftArrow       = "left-arrow"
//    static let imageLuvo            = ""
//    static let imageMenu            = "menu"
//    static let imageNotification    = "bell"
//}
//
//struct ConstantNavigationBarSelectorName {
//    static let selectorPush = "btnNavPush"
//    static let selectorPop  = "btnNavPop"
//    static let selectorMenu = "btnNavOpenMenu"
//}
//
//struct ConstantNavigationButtonTag {
//    static let tagHomeVC = 1
//}

struct ConstantBottomButton {
    static let home = "home"
}

struct ConstantThemeSolidColor {
    static let red      = "#ED000A"
    static let orange   = "#F46C00"
    static let yellow   = "#FDB200"
    static let green    = "#00A62C"
    static let blue     = "#00ADEF"
    static let purple   = "#5B26A6"
    static let violet   = "#A2108C"
}

struct ConstantThemeHomeIcon {
    static let red_gratitude        = "red_gratitude"
    static let red_heart            = "red_heart"
    static let red_mood             = "red_mood"
    static let red_points           = "red_points"
    static let red_sleep            = "red_sleep"
    static let red_steps            = "red_steps"
    static let red_water            = "red_water"
    
    static let orange_gratitude     = "orange_gratitude"
    static let orange_heart         = "orange_heart"
    static let orange_mood          = "orange_mood"
    static let orange_points        = "orange_points"
    static let orange_sleep         = "orange_sleep"
    static let orange_steps         = "orange_steps"
    static let orange_water         = "orange_water"
    
    static let yellow_gratitude     = "yellow_gratitude"
    static let yellow_heart         = "yellow_heart"
    static let yellow_mood          = "yellow_mood"
    static let yellow_points        = "yellow_points"
    static let yellow_sleep         = "yellow_sleep"
    static let yellow_steps         = "yellow_steps"
    static let yellow_water         = "yellow_water"
    
    static let green_gratitude      = "green_gratitude"
    static let green_heart          = "green_heart"
    static let green_mood           = "green_mood"
    static let green_points         = "green_points"
    static let green_sleep          = "green_sleep"
    static let green_steps          = "green_steps"
    static let green_water          = "green_water"
    
    static let sky_gratitude        = "sky_gratitude"
    static let sky_heart            = "sky_heart"
    static let sky_mood             = "sky_mood"
    static let sky_points           = "sky_points"
    static let sky_sleep            = "sky_sleep"
    static let sky_steps            = "sky_steps"
    static let sky_water            = "sky_water"
    
    static let purple_gratitude     = "purple_gratitude"
    static let purple_heart         = "purple_heart"
    static let purple_mood          = "purple_mood"
    static let purple_points        = "purple_points"
    static let purple_sleep         = "purple_sleep"
    static let purple_steps         = "purple_steps"
    static let purple_water         = "purple_water"
    
    static let violet_gratitude     = "violet_gratitude"
    static let violet_heart         = "violet_heart"
    static let violet_mood          = "violet_mood"
    static let violet_points        = "violet_points"
    static let violet_sleep         = "violet_sleep"
    static let violet_steps         = "violet_steps"
    static let violet_water         = "violet_water"
}

struct ConstantLocalNotification {
    static let refreshHomeButtonColor   = "refreshHomeButtonColor"
    static let updateNotificationBadge  = "updateNotificationBadge"
    static let updateNotificationList   = "updateNotificationList"
}

struct ConstantTimeTrackType {
    static let audio = "audio"
    static let video = "video"
}
