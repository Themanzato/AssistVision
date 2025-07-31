// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S? current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current!;
    });
  } 

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Extract text`
  String get homeExtractText {
    return Intl.message(
      'Extract text',
      name: 'homeExtractText',
      desc: '',
      args: [],
    );
  }

  /// `Face recognition`
  String get homeFaces {
    return Intl.message(
      'Face recognition',
      name: 'homeFaces',
      desc: '',
      args: [],
    );
  }

  /// `Take photo`
  String get homeTakePhoto {
    return Intl.message(
      'Take photo',
      name: 'homeTakePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Upload photo`
  String get homeUploadPhoto {
    return Intl.message(
      'Upload photo',
      name: 'homeUploadPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR`
  String get homeScanQR {
    return Intl.message(
      'Scan QR',
      name: 'homeScanQR',
      desc: '',
      args: [],
    );
  }

  /// `Ask for help`
  String get homePedirAyuda {
    return Intl.message(
      'Ask for help',
      name: 'homePedirAyuda',
      desc: '',
      args: [],
    );
  }

  /// `QR`
  String get QR {
    return Intl.message(
      'QR',
      name: 'QR',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get Code {
    return Intl.message(
      'Code',
      name: 'Code',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get homeConfig {
    return Intl.message(
      'Settings',
      name: 'homeConfig',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get homeProfile {
    return Intl.message(
      'Profile',
      name: 'homeProfile',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get homeHelp {
    return Intl.message(
      'Help',
      name: 'homeHelp',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get homeAboutOf {
    return Intl.message(
      'About',
      name: 'homeAboutOf',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get Audio {
    return Intl.message(
      'Audio',
      name: 'Audio',
      desc: '',
      args: [],
    );
  }

  /// `Configure voice output`
  String get ConfigureVoice {
    return Intl.message(
      'Configure voice output',
      name: 'ConfigureVoice',
      desc: '',
      args: [],
    );
  }

  /// `Volume`
  String get Volume {
    return Intl.message(
      'Volume',
      name: 'Volume',
      desc: '',
      args: [],
    );
  }

  /// `Speed`
  String get Speed {
    return Intl.message(
      'Speed',
      name: 'Speed',
      desc: '',
      args: [],
    );
  }

  /// `Speed`
  String get Velocity {
    return Intl.message(
      'Speed',
      name: 'Velocity',
      desc: '',
      args: [],
    );
  }

  /// `Accent`
  String get Accent {
    return Intl.message(
      'Accent',
      name: 'Accent',
      desc: '',
      args: [],
    );
  }

  /// `Adjust volume`
  String get AdjustVolume {
    return Intl.message(
      'Adjust volume',
      name: 'AdjustVolume',
      desc: '',
      args: [],
    );
  }

  /// `Adjust speed`
  String get AdjustSpeed {
    return Intl.message(
      'Adjust speed',
      name: 'AdjustSpeed',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get Language {
    return Intl.message(
      'Language',
      name: 'Language',
      desc: '',
      args: [],
    );
  }

  /// `Select your preferred language`
  String get SelectLanguage {
    return Intl.message(
      'Select your preferred language',
      name: 'SelectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `You selected`
  String get YouSelected {
    return Intl.message(
      'You selected',
      name: 'YouSelected',
      desc: '',
      args: [],
    );
  }

  /// `Accessibility`
  String get Accessibility {
    return Intl.message(
      'Accessibility',
      name: 'Accessibility',
      desc: '',
      args: [],
    );
  }

  /// `Visual accessibility settings`
  String get VisualSettings {
    return Intl.message(
      'Visual accessibility settings',
      name: 'VisualSettings',
      desc: '',
      args: [],
    );
  }

  /// `High contrast`
  String get HighContrast {
    return Intl.message(
      'High contrast',
      name: 'HighContrast',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get DarkMode {
    return Intl.message(
      'Dark mode',
      name: 'DarkMode',
      desc: '',
      args: [],
    );
  }

  /// `Font size`
  String get FontSize {
    return Intl.message(
      'Font size',
      name: 'FontSize',
      desc: '',
      args: [],
    );
  }

  /// `Text size`
  String get TextSize {
    return Intl.message(
      'Text size',
      name: 'TextSize',
      desc: '',
      args: [],
    );
  }

  /// `Text color`
  String get TextColor {
    return Intl.message(
      'Text color',
      name: 'TextColor',
      desc: '',
      args: [],
    );
  }

  /// `Text background color`
  String get TextBackgroundColor {
    return Intl.message(
      'Text background color',
      name: 'TextBackgroundColor',
      desc: '',
      args: [],
    );
  }

  /// `Current word background color`
  String get BackgroundWord {
    return Intl.message(
      'Current word background color',
      name: 'BackgroundWord',
      desc: '',
      args: [],
    );
  }

  /// `Show original and translation`
  String get ShowOriginalAndTranslation {
    return Intl.message(
      'Show original and translation',
      name: 'ShowOriginalAndTranslation',
      desc: '',
      args: [],
    );
  }

  /// `Speech rate`
  String get SpeechRate {
    return Intl.message(
      'Speech rate',
      name: 'SpeechRate',
      desc: '',
      args: [],
    );
  }

  /// `Highlight words`
  String get HighlightWords {
    return Intl.message(
      'Highlight words',
      name: 'HighlightWords',
      desc: '',
      args: [],
    );
  }

  /// `Text alignment`
  String get TextAling {
    return Intl.message(
      'Text alignment',
      name: 'TextAling',
      desc: '',
      args: [],
    );
  }

  /// `Line spacing`
  String get LineSpacing {
    return Intl.message(
      'Line spacing',
      name: 'LineSpacing',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get CloseSession {
    return Intl.message(
      'Log out',
      name: 'CloseSession',
      desc: '',
      args: [],
    );
  }

  /// `This is a test with the selected accent`
  String get TestAccent {
    return Intl.message(
      'This is a test with the selected accent',
      name: 'TestAccent',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `Select language`
  String get settingsSelectLanguage {
    return Intl.message(
      'Select language',
      name: 'settingsSelectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get Camera {
    return Intl.message(
      'Camera',
      name: 'Camera',
      desc: '',
      args: [],
    );
  }

  /// `Turn off flash`
  String get OffFlash {
    return Intl.message(
      'Turn off flash',
      name: 'OffFlash',
      desc: '',
      args: [],
    );
  }

  /// `Turn on flash`
  String get OnFlash {
    return Intl.message(
      'Turn on flash',
      name: 'OnFlash',
      desc: '',
      args: [],
    );
  }

  /// `Failed to read the image. Press 'Continue' to try again.`
  String get PhotoViewNoImage {
    return Intl.message(
      'Failed to read the image. Press \'Continue\' to try again.',
      name: 'PhotoViewNoImage',
      desc: '',
      args: [],
    );
  }

  /// `Image ready to be read! Press 'Continue'.`
  String get PhotoViewYesImage {
    return Intl.message(
      'Image ready to be read! Press \'Continue\'.',
      name: 'PhotoViewYesImage',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get PhotoViewBtnContinue {
    return Intl.message(
      'Continue',
      name: 'PhotoViewBtnContinue',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get PhotoViewBtnCancel {
    return Intl.message(
      'Cancel',
      name: 'PhotoViewBtnCancel',
      desc: '',
      args: [],
    );
  }

  /// `Swipe to change language`
  String get ChangeLanguaje {
    return Intl.message(
      'Swipe to change language',
      name: 'ChangeLanguaje',
      desc: '',
      args: [],
    );
  }

  /// `Enlarge text`
  String get EnlargeText {
    return Intl.message(
      'Enlarge text',
      name: 'EnlargeText',
      desc: '',
      args: [],
    );
  }

  /// `Minimize text`
  String get MinimizeText {
    return Intl.message(
      'Minimize text',
      name: 'MinimizeText',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get Pause {
    return Intl.message(
      'Pause',
      name: 'Pause',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get Play {
    return Intl.message(
      'Play',
      name: 'Play',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Name {
    return Intl.message(
      'Name',
      name: 'Name',
      desc: '',
      args: [],
    );
  }

  /// `Set your name`
  String get SetName {
    return Intl.message(
      'Set your name',
      name: 'SetName',
      desc: '',
      args: [],
    );
  }

  /// `Edit name`
  String get EditName {
    return Intl.message(
      'Edit name',
      name: 'EditName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Email {
    return Intl.message(
      'Email',
      name: 'Email',
      desc: '',
      args: [],
    );
  }

  /// `Set your email`
  String get SetEmail {
    return Intl.message(
      'Set your email',
      name: 'SetEmail',
      desc: '',
      args: [],
    );
  }

  /// `Edit email`
  String get EditEmail {
    return Intl.message(
      'Edit email',
      name: 'EditEmail',
      desc: '',
      args: [],
    );
  }

  /// `QR code not found in the image`
  String get WithoutQR {
    return Intl.message(
      'QR code not found in the image',
      name: 'WithoutQR',
      desc: '',
      args: [],
    );
  }

  /// `No faces detected. Press 'Continue' to try again.`
  String get WithoutFaces {
    return Intl.message(
      'No faces detected. Press \'Continue\' to try again.',
      name: 'WithoutFaces',
      desc: '',
      args: [],
    );
  }

  /// `Faces detected`
  String get face1 {
    return Intl.message(
      'Faces detected',
      name: 'face1',
      desc: '',
      args: [],
    );
  }

  /// `Face`
  String get face2 {
    return Intl.message(
      'Face',
      name: 'face2',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get face3 {
    return Intl.message(
      'and',
      name: 'face3',
      desc: '',
      args: [],
    );
  }

  /// `faces`
  String get face4 {
    return Intl.message(
      'faces',
      name: 'face4',
      desc: '',
      args: [],
    );
  }

  /// `It is`
  String get its {
    return Intl.message(
      'It is',
      name: 'its',
      desc: '',
      args: [],
    );
  }

  /// `Press 'Continue'`
  String get PressContinue {
    return Intl.message(
      'Press \'Continue\'',
      name: 'PressContinue',
      desc: '',
      args: [],
    );
  }

  /// `on the left edge of the image`
  String get horizontalPositionLeftEdge {
    return Intl.message(
      'on the left edge of the image',
      name: 'horizontalPositionLeftEdge',
      desc: '',
      args: [],
    );
  }

  /// `on the right edge of the image`
  String get horizontalPositionLeft {
    return Intl.message(
      'on the right edge of the image',
      name: 'horizontalPositionLeft',
      desc: '',
      args: [],
    );
  }

  /// `in the center of the image`
  String get horizontalPositionSlightlyLeft {
    return Intl.message(
      'in the center of the image',
      name: 'horizontalPositionSlightlyLeft',
      desc: '',
      args: [],
    );
  }

  /// `slightly to the right`
  String get horizontalPositionCenterLeft {
    return Intl.message(
      'slightly to the right',
      name: 'horizontalPositionCenterLeft',
      desc: '',
      args: [],
    );
  }

  /// `slightly to the left`
  String get horizontalPositionCenter {
    return Intl.message(
      'slightly to the left',
      name: 'horizontalPositionCenter',
      desc: '',
      args: [],
    );
  }

  /// `at the top of the image`
  String get horizontalPositionCenterRight {
    return Intl.message(
      'at the top of the image',
      name: 'horizontalPositionCenterRight',
      desc: '',
      args: [],
    );
  }

  /// `at the bottom of the image`
  String get horizontalPositionSlightlyRight {
    return Intl.message(
      'at the bottom of the image',
      name: 'horizontalPositionSlightlyRight',
      desc: '',
      args: [],
    );
  }

  /// `in the center of the image`
  String get horizontalPositionRight {
    return Intl.message(
      'in the center of the image',
      name: 'horizontalPositionRight',
      desc: '',
      args: [],
    );
  }

  /// `slightly lower`
  String get horizontalPositionRightEdge {
    return Intl.message(
      'slightly lower',
      name: 'horizontalPositionRightEdge',
      desc: '',
      args: [],
    );
  }

  /// `slightly higher`
  String get verticalPositionTop {
    return Intl.message(
      'slightly higher',
      name: 'verticalPositionTop',
      desc: '',
      args: [],
    );
  }

  /// `slightly higher`
  String get verticalPositionSlightlyTop {
    return Intl.message(
      'slightly higher',
      name: 'verticalPositionSlightlyTop',
      desc: '',
      args: [],
    );
  }

  /// `center-top`
  String get verticalPositionCenterTop {
    return Intl.message(
      'center-top',
      name: 'verticalPositionCenterTop',
      desc: '',
      args: [],
    );
  }

  /// `center`
  String get verticalPositionCenter {
    return Intl.message(
      'center',
      name: 'verticalPositionCenter',
      desc: '',
      args: [],
    );
  }

  /// `center-bottom`
  String get verticalPositionCenterBottom {
    return Intl.message(
      'center-bottom',
      name: 'verticalPositionCenterBottom',
      desc: '',
      args: [],
    );
  }

  /// `slightly lower`
  String get verticalPositionSlightlyBottom {
    return Intl.message(
      'slightly lower',
      name: 'verticalPositionSlightlyBottom',
      desc: '',
      args: [],
    );
  }

  /// `bottom`
  String get verticalPositionBottom {
    return Intl.message(
      'bottom',
      name: 'verticalPositionBottom',
      desc: '',
      args: [],
    );
  }

  /// `image`
  String get image {
    return Intl.message(
      'image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Face detected.`
  String get TheyMet {
    return Intl.message(
      'Face detected.',
      name: 'TheyMet',
      desc: '',
      args: [],
    );
  }

  /// `Faces detected`
  String get TheyMets {
    return Intl.message(
      'Faces detected',
      name: 'TheyMets',
      desc: '',
      args: [],
    );
  }

  /// `It is`
  String get ThatsIt {
    return Intl.message(
      'It is',
      name: 'ThatsIt',
      desc: '',
      args: [],
    );
  }

  /// `Failed to determine if the face is smiling`
  String get NoSmile {
    return Intl.message(
      'Failed to determine if the face is smiling',
      name: 'NoSmile',
      desc: '',
      args: [],
    );
  }

  /// `Face on the far left edge`
  String get FaceOnTheFarLeft {
    return Intl.message(
      'Face on the far left edge',
      name: 'FaceOnTheFarLeft',
      desc: '',
      args: [],
    );
  }

  /// `Face on the far right edge`
  String get FaceOnTheFarRight {
    return Intl.message(
      'Face on the far right edge',
      name: 'FaceOnTheFarRight',
      desc: '',
      args: [],
    );
  }

  /// `This face is among others`
  String get ThisFaceIsOnTheRightOfThePerson {
    return Intl.message(
      'This face is among others',
      name: 'ThisFaceIsOnTheRightOfThePerson',
      desc: '',
      args: [],
    );
  }

  /// `There is some space between this face and the previous one`
  String get Thereissomespacebetweenthisfaceandthepreviousone {
    return Intl.message(
      'There is some space between this face and the previous one',
      name: 'Thereissomespacebetweenthisfaceandthepreviousone',
      desc: '',
      args: [],
    );
  }

  /// `Pretty close to the person`
  String get Itsprettyclosetotheperson {
    return Intl.message(
      'Pretty close to the person',
      name: 'Itsprettyclosetotheperson',
      desc: '',
      args: [],
    );
  }

  /// `There is a lot of space between this face and the previous one`
  String get SpaceBetweenFace {
    return Intl.message(
      'There is a lot of space between this face and the previous one',
      name: 'SpaceBetweenFace',
      desc: '',
      args: [],
    );
  }

  /// `There is a lot of space between this face and the next one`
  String get MuchSpace {
    return Intl.message(
      'There is a lot of space between this face and the next one',
      name: 'MuchSpace',
      desc: '',
      args: [],
    );
  }

  /// `This is the second face from the left`
  String get secondfacefromleft {
    return Intl.message(
      'This is the second face from the left',
      name: 'secondfacefromleft',
      desc: '',
      args: [],
    );
  }

  /// `This is the second-to-last face on the right`
  String get secondtolastface {
    return Intl.message(
      'This is the second-to-last face on the right',
      name: 'secondtolastface',
      desc: '',
      args: [],
    );
  }

  /// `Smiling ear to ear\n`
  String get smileFull {
    return Intl.message(
      'Smiling ear to ear\n',
      name: 'smileFull',
      desc: '',
      args: [],
    );
  }

  /// `Smiling broadly.\n`
  String get smileBig {
    return Intl.message(
      'Smiling broadly.\n',
      name: 'smileBig',
      desc: '',
      args: [],
    );
  }

  /// `Light smile\n`
  String get smileLight {
    return Intl.message(
      'Light smile\n',
      name: 'smileLight',
      desc: '',
      args: [],
    );
  }

  /// `Looks like a light smile\n`
  String get smileSmall {
    return Intl.message(
      'Looks like a light smile\n',
      name: 'smileSmall',
      desc: '',
      args: [],
    );
  }

  /// `There is a hint of a smile\n`
  String get smileHint {
    return Intl.message(
      'There is a hint of a smile\n',
      name: 'smileHint',
      desc: '',
      args: [],
    );
  }

  /// `Not smiling.\n`
  String get smileNone {
    return Intl.message(
      'Not smiling.\n',
      name: 'smileNone',
      desc: '',
      args: [],
    );
  }

  /// `Eyes not visible\n`
  String get eyesNotVisible {
    return Intl.message(
      'Eyes not visible\n',
      name: 'eyesNotVisible',
      desc: '',
      args: [],
    );
  }

  /// `Both eyes are open\n`
  String get eyesWideOpen {
    return Intl.message(
      'Both eyes are open\n',
      name: 'eyesWideOpen',
      desc: '',
      args: [],
    );
  }

  /// `Both eyes are closed\n`
  String get eyesClosed {
    return Intl.message(
      'Both eyes are closed\n',
      name: 'eyesClosed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to determine the eye state\n`
  String get NoEyes {
    return Intl.message(
      'Failed to determine the eye state\n',
      name: 'NoEyes',
      desc: '',
      args: [],
    );
  }

  /// `Left eye open, right eye closed.\n`
  String get OneOpen {
    return Intl.message(
      'Left eye open, right eye closed.\n',
      name: 'OneOpen',
      desc: '',
      args: [],
    );
  }

  /// `Right eye open, left eye closed.\n`
  String get OpenOne {
    return Intl.message(
      'Right eye open, left eye closed.\n',
      name: 'OpenOne',
      desc: '',
      args: [],
    );
  }

  /// `Eyes half-open\n`
  String get eyesHalfOpen {
    return Intl.message(
      'Eyes half-open\n',
      name: 'eyesHalfOpen',
      desc: '',
      args: [],
    );
  }

  /// `Head turned right.\n`
  String get HeadRigth {
    return Intl.message(
      'Head turned right.\n',
      name: 'HeadRigth',
      desc: '',
      args: [],
    );
  }

  /// `Head turned left.\n`
  String get HeadLeft {
    return Intl.message(
      'Head turned left.\n',
      name: 'HeadLeft',
      desc: '',
      args: [],
    );
  }

  /// `Head tilted to the right.\n`
  String get HeadRigth2 {
    return Intl.message(
      'Head tilted to the right.\n',
      name: 'HeadRigth2',
      desc: '',
      args: [],
    );
  }

  /// `Head tilted to the left.\n`
  String get HeadLeft2 {
    return Intl.message(
      'Head tilted to the left.\n',
      name: 'HeadLeft2',
      desc: '',
      args: [],
    );
  }

  /// `Head centered.\n`
  String get HeadCenter {
    return Intl.message(
      'Head centered.\n',
      name: 'HeadCenter',
      desc: '',
      args: [],
    );
  }

  /// `Head straight.\n`
  String get HeadCenter2 {
    return Intl.message(
      'Head straight.\n',
      name: 'HeadCenter2',
      desc: '',
      args: [],
    );
  }

  /// `Left eye closed, right eye open\n`
  String get leftEyeClosedRightOpen {
    return Intl.message(
      'Left eye closed, right eye open\n',
      name: 'leftEyeClosedRightOpen',
      desc: '',
      args: [],
    );
  }

  /// `Right eye closed, left eye open\n`
  String get rightEyeClosedLeftOpen {
    return Intl.message(
      'Right eye closed, left eye open\n',
      name: 'rightEyeClosedLeftOpen',
      desc: '',
      args: [],
    );
  }

  /// `Left eye wide open, right half-open or closed\n`
  String get leftEyeWideRightHalf {
    return Intl.message(
      'Left eye wide open, right half-open or closed\n',
      name: 'leftEyeWideRightHalf',
      desc: '',
      args: [],
    );
  }

  /// `Right eye wide open, left half-open or closed\n`
  String get rightEyeWideLeftHalf {
    return Intl.message(
      'Right eye wide open, left half-open or closed\n',
      name: 'rightEyeWideLeftHalf',
      desc: '',
      args: [],
    );
  }

  /// `Left eye half-open, right closed\n`
  String get leftEyeHalfRightClosed {
    return Intl.message(
      'Left eye half-open, right closed\n',
      name: 'leftEyeHalfRightClosed',
      desc: '',
      args: [],
    );
  }

  /// `Right eye half-open, left closed\n`
  String get rightEyeHalfLeftClosed {
    return Intl.message(
      'Right eye half-open, left closed\n',
      name: 'rightEyeHalfLeftClosed',
      desc: '',
      args: [],
    );
  }

  /// `One eye is more open than the other\n`
  String get eyesDifferent {
    return Intl.message(
      'One eye is more open than the other\n',
      name: 'eyesDifferent',
      desc: '',
      args: [],
    );
  }

  /// `Head position not visible\n`
  String get headPositionNotVisible {
    return Intl.message(
      'Head position not visible\n',
      name: 'headPositionNotVisible',
      desc: '',
      args: [],
    );
  }

  /// `facing the camera`
  String get verticalTiltFront {
    return Intl.message(
      'facing the camera',
      name: 'verticalTiltFront',
      desc: '',
      args: [],
    );
  }

  /// `facing right`
  String get verticalTiltRight {
    return Intl.message(
      'facing right',
      name: 'verticalTiltRight',
      desc: '',
      args: [],
    );
  }

  /// `facing left`
  String get verticalTiltLeft {
    return Intl.message(
      'facing left',
      name: 'verticalTiltLeft',
      desc: '',
      args: [],
    );
  }

  /// `and the head is straight`
  String get horizontalTiltStraight {
    return Intl.message(
      'and the head is straight',
      name: 'horizontalTiltStraight',
      desc: '',
      args: [],
    );
  }

  /// `and the head is tilted to the right`
  String get horizontalTiltRight {
    return Intl.message(
      'and the head is tilted to the right',
      name: 'horizontalTiltRight',
      desc: '',
      args: [],
    );
  }

  /// `and the head is tilted to the left`
  String get horizontalTiltLeft {
    return Intl.message(
      'and the head is tilted to the left',
      name: 'horizontalTiltLeft',
      desc: '',
      args: [],
    );
  }

  /// `Head`
  String get headPosition {
    return Intl.message(
      'Head',
      name: 'headPosition',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR code`
  String get ScanQR {
    return Intl.message(
      'Scan QR code',
      name: 'ScanQR',
      desc: '',
      args: [],
    );
  }

  /// `No objects detected. Try again.`
  String get noObjectsDetected {
    return Intl.message(
      'No objects detected. Try again.',
      name: 'noObjectsDetected',
      desc: '',
      args: [],
    );
  }

  /// `The following objects were detected:`
  String get objectsDetected {
    return Intl.message(
      'The following objects were detected:',
      name: 'objectsDetected',
      desc: '',
      args: [],
    );
  }

  /// `There was an error processing the image. Try again.`
  String get imageProcessingError {
    return Intl.message(
      'There was an error processing the image. Try again.',
      name: 'imageProcessingError',
      desc: '',
      args: [],
    );
  }

  /// `No objects were detected with sufficient confidence.`
  String get noObjectsWithConfidence {
    return Intl.message(
      'No objects were detected with sufficient confidence.',
      name: 'noObjectsWithConfidence',
      desc: '',
      args: [],
    );
  }

  /// `It seems there are several objects in the image. These are:`
  String get severalObjects {
    return Intl.message(
      'It seems there are several objects in the image. These are:',
      name: 'severalObjects',
      desc: '',
      args: [],
    );
  }

  /// `It seems there is a`
  String get Itseemsthatthereisa {
    return Intl.message(
      'It seems there is a',
      name: 'Itseemsthatthereisa',
      desc: '',
      args: [],
    );
  }

  /// `in the picture`
  String get inthepicture {
    return Intl.message(
      'in the picture',
      name: 'inthepicture',
      desc: '',
      args: [],
    );
  }

  /// `and a`
  String get andA {
    return Intl.message(
      'and a',
      name: 'andA',
      desc: '',
      args: [],
    );
  }

  /// `Object recognition`
  String get ObjectRecognition {
    return Intl.message(
      'Object recognition',
      name: 'ObjectRecognition',
      desc: '',
      args: [],
    );
  }

  /// `with confidence`
  String get trust {
    return Intl.message(
      'with confidence',
      name: 'trust',
      desc: '',
      args: [],
    );
  }

  /// `Text is already in the target language`
  String get textList {
    return Intl.message(
      'Text is already in the target language',
      name: 'textList',
      desc: '',
      args: [],
    );
  }

  /// `Select translation language`
  String get SelectTranslationLanguage {
    return Intl.message(
      'Select translation language',
      name: 'SelectTranslationLanguage',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get OK {
    return Intl.message(
      'OK',
      name: 'OK',
      desc: '',
      args: [],
    );
  }

  /// `Reboot`
  String get Reboot {
    return Intl.message(
      'Reboot',
      name: 'Reboot',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get Translate {
    return Intl.message(
      'Translate',
      name: 'Translate',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Save {
    return Intl.message(
      'Save',
      name: 'Save',
      desc: '',
      args: [],
    );
  }

  /// `Location service disabled.`
  String get LocationDisabledError {
    return Intl.message(
      'Location service disabled.',
      name: 'LocationDisabledError',
      desc: '',
      args: [],
    );
  }

  /// `Location access denied.`
  String get LocationPermissionDeniedError {
    return Intl.message(
      'Location access denied.',
      name: 'LocationPermissionDeniedError',
      desc: '',
      args: [],
    );
  }

  /// `Location access permanently denied.`
  String get LocationPermissionPermanentlyDeniedError {
    return Intl.message(
      'Location access permanently denied.',
      name: 'LocationPermissionPermanentlyDeniedError',
      desc: '',
      args: [],
    );
  }

  /// `Current address unavailable`
  String get CurrentAddressNotAvailable {
    return Intl.message(
      'Current address unavailable',
      name: 'CurrentAddressNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Error retrieving address`
  String get CurrentAddressError {
    return Intl.message(
      'Error retrieving address',
      name: 'CurrentAddressError',
      desc: '',
      args: [],
    );
  }

  /// `I need help! I am located at: `
  String get NeedHelpMessage {
    return Intl.message(
      'I need help! I am located at: ',
      name: 'NeedHelpMessage',
      desc: '',
      args: [],
    );
  }

  /// `SMS`
  String get SMS {
    return Intl.message(
      'SMS',
      name: 'SMS',
      desc: '',
      args: [],
    );
  }

  /// `You can send SMS`
  String get SendSMS {
    return Intl.message(
      'You can send SMS',
      name: 'SendSMS',
      desc: '',
      args: [],
    );
  }

  /// `Contact number: +33$_trustedContactNumber`
  String get ContactNumber {
    return Intl.message(
      'Contact number: +33\$_trustedContactNumber',
      name: 'ContactNumber',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open SMS app.`
  String get CannotLaunchSMSAppError {
    return Intl.message(
      'Unable to open SMS app.',
      name: 'CannotLaunchSMSAppError',
      desc: '',
      args: [],
    );
  }

  /// `SMS sending error:`
  String get SMSSendError {
    return Intl.message(
      'SMS sending error:',
      name: 'SMSSendError',
      desc: '',
      args: [],
    );
  }

  /// `Contact number or address unavailable.`
  String get ContactOrAddressNotAvailableError {
    return Intl.message(
      'Contact number or address unavailable.',
      name: 'ContactOrAddressNotAvailableError',
      desc: '',
      args: [],
    );
  }

  /// `Add trusted contact`
  String get AddTrustedContactTitle {
    return Intl.message(
      'Add trusted contact',
      name: 'AddTrustedContactTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get NameInputHint {
    return Intl.message(
      'Name',
      name: 'NameInputHint',
      desc: '',
      args: [],
    );
  }

  /// `Number (10 digits)`
  String get NumberInputHint {
    return Intl.message(
      'Number (10 digits)',
      name: 'NumberInputHint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid number. Please ensure it contains 10 digits.`
  String get InvalidNumberErrorMessage {
    return Intl.message(
      'Invalid number. Please ensure it contains 10 digits.',
      name: 'InvalidNumberErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to add this person as a trusted contact?`
  String get ConfirmTrustedContactMessage {
    return Intl.message(
      'Are you sure you want to add this person as a trusted contact?',
      name: 'ConfirmTrustedContactMessage',
      desc: '',
      args: [],
    );
  }

  /// `Trusted contact successfully added!`
  String get TrustedContactAddedSuccessMessage {
    return Intl.message(
      'Trusted contact successfully added!',
      name: 'TrustedContactAddedSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Trusted contact`
  String get TrustedContact {
    return Intl.message(
      'Trusted contact',
      name: 'TrustedContact',
      desc: '',
      args: [],
    );
  }

  /// `+52`
  String get mcd {
    return Intl.message(
      '+52',
      name: 'mcd',
      desc: '',
      args: [],
    );
  }

  /// `Trusted contact not saved.`
  String get NoContactSavedMessage {
    return Intl.message(
      'Trusted contact not saved.',
      name: 'NoContactSavedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Phone call permission denied.`
  String get PhonePermissionDeniedMessage {
    return Intl.message(
      'Phone call permission denied.',
      name: 'PhonePermissionDeniedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get Error {
    return Intl.message(
      'Error',
      name: 'Error',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get Close {
    return Intl.message(
      'Close',
      name: 'Close',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get Location {
    return Intl.message(
      'Location',
      name: 'Location',
      desc: '',
      args: [],
    );
  }

  /// `Ask for help`
  String get askForHelp {
    return Intl.message(
      'Ask for help',
      name: 'askForHelp',
      desc: '',
      args: [],
    );
  }

  /// `Edit trusted contact`
  String get EditTrustedContact {
    return Intl.message(
      'Edit trusted contact',
      name: 'EditTrustedContact',
      desc: '',
      args: [],
    );
  }

  /// `Obtaining location...`
  String get ObteniendoUbicacion {
    return Intl.message(
      'Obtaining location...',
      name: 'ObteniendoUbicacion',
      desc: '',
      args: [],
    );
  }

  /// `Obtaining address...`
  String get ObteniendoDireccion {
    return Intl.message(
      'Obtaining address...',
      name: 'ObteniendoDireccion',
      desc: '',
      args: [],
    );
  }

  /// `No trusted contact`
  String get NoContact {
    return Intl.message(
      'No trusted contact',
      name: 'NoContact',
      desc: '',
      args: [],
    );
  }

  /// `Error getting location`
  String get NoUbication {
    return Intl.message(
      'Error getting location',
      name: 'NoUbication',
      desc: '',
      args: [],
    );
  }

  /// `Address not found`
  String get NoUbication2 {
    return Intl.message(
      'Address not found',
      name: 'NoUbication2',
      desc: '',
      args: [],
    );
  }

  /// `Error retrieving address`
  String get ErrorUbication {
    return Intl.message(
      'Error retrieving address',
      name: 'ErrorUbication',
      desc: '',
      args: [],
    );
  }

  /// `Connection error with address service`
  String get ErrorUbications {
    return Intl.message(
      'Connection error with address service',
      name: 'ErrorUbications',
      desc: '',
      args: [],
    );
  }

  /// `Cannot send message without contact or location`
  String get NoMessage {
    return Intl.message(
      'Cannot send message without contact or location',
      name: 'NoMessage',
      desc: '',
      args: [],
    );
  }

  /// `Help! I am located at: `
  String get Help1 {
    return Intl.message(
      'Help! I am located at: ',
      name: 'Help1',
      desc: '',
      args: [],
    );
  }

  /// `Location on Google Maps:`
  String get UbicationMaps {
    return Intl.message(
      'Location on Google Maps:',
      name: 'UbicationMaps',
      desc: '',
      args: [],
    );
  }

  /// `Unable to send message`
  String get NoSendMessage {
    return Intl.message(
      'Unable to send message',
      name: 'NoSendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Location service disabled`
  String get NoServiceUbication {
    return Intl.message(
      'Location service disabled',
      name: 'NoServiceUbication',
      desc: '',
      args: [],
    );
  }

  /// `Location access denied`
  String get NoPermissions {
    return Intl.message(
      'Location access denied',
      name: 'NoPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Location access permanently denied`
  String get NoPermissions2 {
    return Intl.message(
      'Location access permanently denied',
      name: 'NoPermissions2',
      desc: '',
      args: [],
    );
  }

  /// `Add or change trusted contact`
  String get Contact {
    return Intl.message(
      'Add or change trusted contact',
      name: 'Contact',
      desc: '',
      args: [],
    );
  }

  /// `Your location`
  String get TuUbicacion {
    return Intl.message(
      'Your location',
      name: 'TuUbicacion',
      desc: '',
      args: [],
    );
  }

  /// `Send help message`
  String get SendMessage {
    return Intl.message(
      'Send help message',
      name: 'SendMessage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}