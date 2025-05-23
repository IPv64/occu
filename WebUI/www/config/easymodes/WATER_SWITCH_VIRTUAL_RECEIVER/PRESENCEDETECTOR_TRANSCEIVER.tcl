#!/bin/tclsh

source [file join $env(DOCUMENT_ROOT) config/easymodes/em_common.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/EnterFreeValue.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/etc/options.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/etc/hmip_helper.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/etc/uiElements.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/etc/motionDetectorOnTimeHint.tcl]

set PROFILES_MAP(0)  "\${expert}"
set PROFILES_MAP(1)  "\${switch_toggle}"
set PROFILES_MAP(2)  "\${light_stairway}"
set PROFILES_MAP(3)  "\${no_action}"

set PROFILE_0(UI_HINT)  0
set PROFILE_0(UI_DESCRIPTION)  "Expertenprofil"
set PROFILE_0(UI_TEMPLATE)    "Expertenprofil"

# hier folgen die verschiedenen Profile

set PROFILE_1(SHORT_COND_VALUE_HI) {150 range 0 - 255}
set PROFILE_1(SHORT_COND_VALUE_LO) {50 range 0 - 255}

# SPHM-833
set PROFILE_1(SHORT_CT_OFF) {2 0}
set PROFILE_1(SHORT_CT_OFFDELAY) {3 0 2}
set PROFILE_1(SHORT_CT_ON) {3 0 2}
set PROFILE_1(SHORT_CT_ONDELAY) {2 0}
set PROFILE_1(SHORT_JT_OFF) {1 3}
set PROFILE_1(SHORT_JT_OFFDELAY) {6 5}
set PROFILE_1(SHORT_JT_ON) {4 6}
set PROFILE_1(SHORT_JT_ONDELAY) {3 2}
set PROFILE_1(SHORT_MULTIEXECUTE) {0 false}
set PROFILE_1(SHORT_OFFDELAY_TIME_BASE) {0 range 0 - 7}
set PROFILE_1(SHORT_OFFDELAY_TIME_FACTOR) {0 range 0 - 31}
set PROFILE_1(SHORT_OFF_TIME_BASE) {7 range 0 - 7}
set PROFILE_1(SHORT_OFF_TIME_FACTOR) {31 range 0 - 31}
set PROFILE_1(SHORT_OFF_TIME_MODE) 0
set PROFILE_1(SHORT_ONDELAY_TIME_BASE) {0 range 0 - 7}
set PROFILE_1(SHORT_ONDELAY_TIME_FACTOR) {0 range 0 - 31}
set PROFILE_1(SHORT_ON_TIME_BASE) {7 range 0 - 7}
set PROFILE_1(SHORT_ON_TIME_FACTOR) {31 range 0 - 31}
set PROFILE_1(SHORT_ON_TIME_MODE) 0
set PROFILE_1(SHORT_PROFILE_ACTION_TYPE) 1
set PROFILE_1(UI_DESCRIPTION)  "Beim Ausl&ouml;sen des Sensors wird der Schalter mindestens f&uuml;r die eingestellte Zeit eingeschaltet."
set PROFILE_1(UI_TEMPLATE)    $PROFILE_1(UI_DESCRIPTION)
set PROFILE_1(UI_HINT)  1


set PROFILE_2(SHORT_COND_VALUE_HI) {150 range 0 - 255}
set PROFILE_2(SHORT_COND_VALUE_LO) {50 range 0 - 255}
# SPHM-833
set PROFILE_2(SHORT_CT_OFF) 2
set PROFILE_2(SHORT_CT_OFFDELAY) {3 2}
set PROFILE_2(SHORT_CT_ON) {3 2}
set PROFILE_2(SHORT_CT_ONDELAY) 2
set PROFILE_2(SHORT_JT_OFF) 1
set PROFILE_2(SHORT_JT_OFFDELAY) 3
set PROFILE_2(SHORT_JT_ON) 3
set PROFILE_2(SHORT_JT_ONDELAY) 3
set PROFILE_2(SHORT_MULTIEXECUTE) {0 false}
set PROFILE_2(SHORT_OFFDELAY_TIME_BASE) {0 range 0 - 7}
set PROFILE_2(SHORT_OFFDELAY_TIME_FACTOR) {0 range 0 - 31}
set PROFILE_2(SHORT_OFF_TIME_BASE) {7 range 0 - 7}
set PROFILE_2(SHORT_OFF_TIME_FACTOR) {31 range 0 - 31}
set PROFILE_2(SHORT_OFF_TIME_MODE) 0
set PROFILE_2(SHORT_ONDELAY_TIME_BASE) {0 range 0 - 7}
set PROFILE_2(SHORT_ONDELAY_TIME_FACTOR) {0 range 0 - 31}
set PROFILE_2(SHORT_ON_TIME_BASE) {5 range 0 - 7}
set PROFILE_2(SHORT_ON_TIME_FACTOR) {1 range 0 - 31}
set PROFILE_2(SHORT_ON_TIME_MODE) {0 1}
set PROFILE_2(SHORT_PROFILE_ACTION_TYPE) 1
set PROFILE_2(UI_DESCRIPTION)  "Beim Ausl&ouml;sen des Sensors wird der Schalter mindestens f&uuml;r die eingestellte Zeit ohne Verz&ouml;gerung eingeschaltet."
set PROFILE_2(UI_TEMPLATE)    $PROFILE_2(UI_DESCRIPTION)
set PROFILE_2(UI_HINT)  2

set PROFILE_3(SHORT_JT_OFF)      0
set PROFILE_3(SHORT_JT_ON)      0
set PROFILE_3(SHORT_JT_OFFDELAY)  0
set PROFILE_3(SHORT_JT_ONDELAY)    0
set PROFILE_3(UI_DESCRIPTION)  "Der Bewegungsmelder ist au&szlig;er Betrieb."
set PROFILE_3(UI_TEMPLATE)    $PROFILE_3(UI_DESCRIPTION)
set PROFILE_3(UI_HINT)  3

# hier folgen die eventuellen Subsets

proc set_htmlParams {iface address pps pps_descr special_input_id peer_type} {

  global url receiver_address sender_address  dev_descr_sender dev_descr_receiver
  upvar PROFILES_MAP  PROFILES_MAP
  upvar HTML_PARAMS   HTML_PARAMS
  upvar PROFILE_PNAME PROFILE_PNAME
  upvar $pps          ps      
  upvar $pps_descr    ps_descr

  foreach pro [array names PROFILES_MAP] {
    upvar PROFILE_$pro PROFILE_$pro
  }

  set cur_profile [get_cur_profile2 ps PROFILES_MAP PROFILE_TMP $peer_type]

  if {($cur_profile == 1) && ($dev_descr_receiver(PARENT_TYPE) == "HmIP-WHS2")} {
    set modifiedCondType  "{SHORT_CT_OFFDELAY {int 0}} {SHORT_CT_ON {int 0}}"
    catch {puts "[xmlrpc $url putParamset [list string $receiver_address] [list string $sender_address] [list struct $modifiedCondType]]"}
    set ps(SHORT_CT_OFFDELAY) 0
    set ps(SHORT_CT_ON) 0
  }


  #global SUBSETS
  set name "x"
  set i 1
  while {$name != ""} {
    upvar SUBSET_$i SUBSET_$i
    array set subset [array get SUBSET_$i]
    set name ""
    catch {set name $subset(NAME)}
    array_clear subset
    incr i
  }
  
#  die Texte der Platzhalter einlesen
  puts "<script type=\"text/javascript\">getLangInfo('$dev_descr_sender(TYPE)', '$dev_descr_receiver(TYPE)');</script>"
  puts "<script type=\"text/javascript\">getLangInfo_Special('HmIP_DEVICES.txt');</script>"

  set prn 0
  append HTML_PARAMS(separate_$prn) "<div id=\"param_$prn\"><textarea id=\"profile_$prn\" style=\"display:none\">"
  append HTML_PARAMS(separate_$prn) [cmd_link_paramset2 $iface $address ps_descr ps "LINK" ${special_input_id}_$prn]
  append HTML_PARAMS(separate_$prn) "</textarea></div>"

#1 Switch toggle
  incr prn
  if {$cur_profile == $prn} then {array set PROFILE_$prn [array get ps]}
  append HTML_PARAMS(separate_$prn) "<div id=\"param_$prn\"><textarea id=\"profile_$prn\" style=\"display:none\">"
  append HTML_PARAMS(separate_$prn) "\${description_$prn}"
  append HTML_PARAMS(separate_$prn) "<table class=\"ProfileTbl\">"

  set pref 0
  # ONDELAY
  append HTML_PARAMS(separate_$prn) "[getTimeSelector ONDELAY_TIME_FACTOR_DESCR ps PROFILE_$prn delay $prn $special_input_id SHORT_ONDELAY_TIME TIMEBASE_LONG]"

  # ON_TIME
  append HTML_PARAMS(separate_$prn) "[getTimeSelector ON_TIME_FACTOR_DESCR ps PROFILE_$prn timeOnOff $prn $special_input_id SHORT_ON_TIME TIMEBASE_LONG]"

  append HTML_PARAMS(separate_$prn) "[getMotionDetectorOnTimeHint]"

  append HTML_PARAMS(separate_$prn) "<tr><td colspan =\"2\"><hr></td></tr>"
  append HTML_PARAMS(separate_$prn) "</table></textarea></div>"

  incr pref
  # Brightness
  EnterBrightnessHmIP $prn $pref ${special_input_id} ps ps_descr SHORT_COND_VALUE_LO help_active_GE_LO
  incr pref
  EnterBrightnessHmIP $prn $pref ${special_input_id} ps ps_descr SHORT_COND_VALUE_HI help_active_LT_LO HI

  #2  Treppenhauslicht
  incr prn
  if {$cur_profile == $prn} then {array set PROFILE_$prn [array get ps]}
  append HTML_PARAMS(separate_$prn) "<div id=\"param_$prn\"><textarea id=\"profile_$prn\" style=\"display:none\">"
  append HTML_PARAMS(separate_$prn) "\${description_$prn}"
  append HTML_PARAMS(separate_$prn) "<table class=\"ProfileTbl\">"

  set pref 1

  append HTML_PARAMS(separate_$prn)  "<tr><td>\${ON_TIME_MODE}</td><td>"
  array_clear options
  set options(0) "\${absolute}"
  set options(1) "\${minimal}"
  append HTML_PARAMS(separate_$prn) [get_ComboBox options SHORT_ON_TIME_MODE separate_${special_input_id}_$prn\_$pref PROFILE_$prn SHORT_ON_TIME_MODE "onchange=\"changeHint(parseInt(this.value), $prn);\""]
  append HTML_PARAMS(separate_$prn) "&nbsp<input type=\"button\"  value=\${help} onclick=\"MD_link_help();\">"
  append HTML_PARAMS(separate_$prn) "</td></tr>"

  # ON_TIME
  append HTML_PARAMS(separate_$prn) "[getTimeSelector ON_TIME_FACTOR_DESCR ps PROFILE_$prn timeOnOff $prn $special_input_id SHORT_ON_TIME TIMEBASE_LONG]"

  # ONDELAY
  append HTML_PARAMS(separate_$prn) "[getTimeSelector ONDELAY_TIME_FACTOR_DESCR ps PROFILE_$prn delay $prn $special_input_id SHORT_ONDELAY_TIME TIMEBASE_LONG]"

  append HTML_PARAMS(separate_$prn) "[getMotionDetectorOnTimeHint $prn]"

  append HTML_PARAMS(separate_$prn) "<script type=\"text/javascript\">"
    append HTML_PARAMS(separate_$prn) "changeHint = function(mode, prn) {"
      append HTML_PARAMS(separate_$prn) "var hintElm = jQuery(\"\[name='hintOnTime_\"+prn+\"'\]\"),"
      append HTML_PARAMS(separate_$prn) "onTimeModeDescrElm = jQuery(\"\[name='onTimeFactorDescr'\]\"),"
      append HTML_PARAMS(separate_$prn) "extensionMinimalElm = jQuery(\"\[name='extensionMinimal'\]\").eq([expr $prn - 1]);"

      append HTML_PARAMS(separate_$prn) "if (mode == 0) {"
        append HTML_PARAMS(separate_$prn) "extensionMinimalElm.hide();"
        append HTML_PARAMS(separate_$prn) "onTimeModeDescrElm.text(translateKey('lblOnTime'));"
      append HTML_PARAMS(separate_$prn) "} else {"
        append HTML_PARAMS(separate_$prn) "extensionMinimalElm.show();"
        append HTML_PARAMS(separate_$prn) "onTimeModeDescrElm.text(translateKey('lblMinOnTime'));"
      append HTML_PARAMS(separate_$prn) "}"
    append HTML_PARAMS(separate_$prn) "};"

    append HTML_PARAMS(separate_$prn) "var mode=parseInt($ps(SHORT_ON_TIME_MODE)), _prn=$prn;"

    append HTML_PARAMS(separate_$prn) "window.setTimeout(function(){"
      append HTML_PARAMS(separate_$prn) "changeHint(mode, _prn);"
    append HTML_PARAMS(separate_$prn) "},50);"
  append HTML_PARAMS(separate_$prn) "</script>"

  append HTML_PARAMS(separate_$prn) "<tr><td colspan =\"2\"><hr></td></tr>"
  append HTML_PARAMS(separate_$prn) "</table></textarea></div>"

  incr pref
  # Brightness
  EnterBrightnessHmIP $prn $pref ${special_input_id} ps ps_descr SHORT_COND_VALUE_LO help_active_LT_LO
  incr pref
  EnterBrightnessHmIP $prn $pref ${special_input_id} ps ps_descr SHORT_COND_VALUE_HI help_active_LT_LO HI

#3
  incr prn
  append HTML_PARAMS(separate_$prn) "<div id=\"param_$prn\"><textarea id=\"profile_$prn\" style=\"display:none\">"
  append HTML_PARAMS(separate_$prn) "\${description_$prn}"
  append HTML_PARAMS(separate_$prn) "</textarea></div>"

}

constructor
