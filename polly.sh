#!/bin/bash
# Array of valid languages and their corresponding voices
VALID_LANGUAGES=("ar-AE" "nl-BE" "ca-ES" "yue-CN" "cmn-CN" "da-DK" "nl-NL" "en-AU" "en-GB" "en-IN" "en-IE" "en-NZ" "en-ZA" "en-US" "fi-FI" "fr-CA" "fr-FR" "de-DE" "de-AT" "hi-IN" "it-IT" "ja-JP" "ko-KR" "nb-NO" "pl-PL" "pt-BR" "pt-PT" "es-ES" "es-MX" "es-US" "sv-SE")

declare -A LANGUAGE_VOICES

# Assign voices for each language
LANGUAGE_VOICES["ar-AE"]="Hala"
LANGUAGE_VOICES["nl-BE"]="Lisa"
LANGUAGE_VOICES["ca-ES"]="Arlet"
LANGUAGE_VOICES["yue-CN"]="Hiujin"
LANGUAGE_VOICES["cmn-CN"]="Zhiyu"
LANGUAGE_VOICES["da-DK"]="Sofie"
LANGUAGE_VOICES["nl-NL"]="Laura"
LANGUAGE_VOICES["en-AU"]="Olivia"
LANGUAGE_VOICES["en-GB"]="Amy Emma Brian Arthur"
LANGUAGE_VOICES["en-IN"]="Kajal"
LANGUAGE_VOICES["en-IE"]="Niamh"
LANGUAGE_VOICES["en-NZ"]="Aria"
LANGUAGE_VOICES["en-ZA"]="Ayanda"
LANGUAGE_VOICES["en-US"]="Joanna Ivy Kendra Kimberly Salli Joey Justin Kevin Matthew Ruth Stephen"
LANGUAGE_VOICES["fi-FI"]="Suvi"
LANGUAGE_VOICES["fr-CA"]="Gabrielle Liam"
LANGUAGE_VOICES["fr-FR"]="Lea Remi"
LANGUAGE_VOICES["de-DE"]="Vicki Daniel"PE/9nqF/fXH54CJpH36zp4U+3kz4qh8T1ypXfibY
LANGUAGE_VOICES["pt-BR"]="Camila Vitoria Thiago"
LANGUAGE_VOICES["pt-PT"]="Ines"
LANGUAGE_VOICES["es-ES"]="Lucia Sergio"
LANGUAGE_VOICES["es-MX"]="Mia Andres"
LANGUAGE_VOICES["es-US"]="Lupe Pedro"
LANGUAGE_VOICES["sv-SE"]="Elin"

# Function to display valid options and values
function display_help() {
  echo "Valid options:"
  echo "-l, --language [LANGUAGE_CODE]: Set the language code. (default : en-US)"
  echo "-v, --voice [VOICE_ID]: Set the voice ID. (default : Joanna)"
  echo "--newscaster: Enable newscaster style for eligible voices."
  echo "--help: Display this help message."
  echo ""
  echo "Valid language codes and voices:"
  for language in "${!LANGUAGE_VOICES[@]}"; do
    voices="${LANGUAGE_VOICES[$language]}"
    echo "Language: $language, Voices: $voices"
  done
}

# Function to check if the provided voice is valid for the given language
function is_valid_voice() {
  local voice=$1
  local language=$2
  if [[ -v LANGUAGE_VOICES[$language] ]]; then
    local voices="${LANGUAGE_VOICES[$language]}"
    for valid_voice in $voices; do
      if [[ "$voice" == "$valid_voice" ]]; then
        return 0
      fi
    done
  fi
  return 1
}

# Process command-line arguments
TEXT=""
VOICE="" #default set later depending on language
# LANGUAGE="en-US" #default to american (Joanna)
LANGUAGE="fr-FR" #default to french (Lea)
# LANGUAGE="en-GB" #default to british (Amy)
NEWSCASTER_STYLE=false

# Check if no arguments are provided or if the --help option is used
if [[ $# -eq 0 ]] || [[ "$1" == "--help" ]]; then
  display_help
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--voice)
      shift
      VOICE=$1
      ;;
    -l|--language)
      shift
      LANGUAGE=$1
      ;;
    --newscaster)
      NEWSCASTER_STYLE=true
      ;;
    *)
      TEXT+="$1 "
      ;;
  esac
  shift
done

# Remove leading/trailing whitespaces
TEXT=${TEXT%% }
TEXT=${TEXT%% }
TEXT=${TEXT%% }

# Replace spaces with underscores in the name
NAME=$(echo "$TEXT" | sed 's/ /_/g')

# Cut if NAME is too long
if [ ${#NAME} -gt 100 ]; then
  NAME=${NAME:0:100}
fi

# Check if the provided language is valid
if ! [[ " ${VALID_LANGUAGES[@]} " =~ " $LANGUAGE " ]]; then
  echo "Invalid language. Valid languages are: ${VALID_LANGUAGES[*]}"
  exit 1
fi

# If no voice is provided, use the default voice for the language (first of the list)
if [[ -z "$VOICE" ]]; then
  VOICE=$(echo "${LANGUAGE_VOICES[$LANGUAGE]}" | awk '{print $1}')
fi

# Check if the provided voice is valid for the given language
if ! is_valid_voice "$VOICE" "$LANGUAGE"; then
  echo "Invalid voice for the selected language. Valid voices for $LANGUAGE are: ${LANGUAGE_VOICES[$LANGUAGE]}"
  exit 1
fi

# Add newscaster style if enabled and voice is valid
if $NEWSCASTER_STYLE && [[ $VOICE == "Amy" || $VOICE == "Joanna" || $VOICE == "Lupe" || $VOICE == "Matthew" ]]; then
  MP3_PATH="$HOME/Audio/polly/$LANGUAGE/$VOICE/Newscaster/$NAME.mp3"
  TEXT_SSML="<speak><amazon:domain name='news'>$TEXT</amazon:domain></speak>"
else
  MP3_PATH="$HOME/Audio/polly/$LANGUAGE/$VOICE/$NAME.mp3"
  TEXT_SSML="<speak>$TEXT</speak>"
fi

# Display for debugging
echo "_ LANGUAGE = $LANGUAGE _"
echo "_ VOICE = $VOICE _"
echo "_ TEXT = $TEXT _"
echo "_ TEXT_SSML = $TEXT_SSML _"
echo "_ NAME = $NAME _"
echo "_ MP3_PATH = $MP3_PATH _"
FOLDER_PATH=$(dirname "$MP3_PATH")
echo "_ FOLDER_PATH = $FOLDER_PATH _"

# Create the directory if it doesn't exist
mkdir -p "$FOLDER_PATH" 2>/dev/null

# Request TTS AWS Polly only if the file doesn't exist
echo
if [ ! -f "$MP3_PATH" ]; then
  aws polly synthesize-speech \
    --output-format mp3 \
	--text-type ssml \
    --region us-east-1 \
    --engine neural \
    --voice-id "$VOICE" \
    --language-code "$LANGUAGE" \
    --text "$TEXT_SSML" \
    "$MP3_PATH" > /dev/null
	echo "Audio file was created (\"$MP3_PATH\")"
else
	echo "Audio file already exist (\"$MP3_PATH\")"
fi
echo

function mute_sinks() {
  for SINK in $(pactl list sink-inputs | awk '/Sink Input #/{ sub(/#/," ");  printf $3" "}' | head -c -1); do
    pactl set-sink-input-mute "$SINK" 1
  done
}

function unmute_sinks() {
  for SINK in $(pactl list sink-inputs | awk '/Sink Input #/{ sub(/#/," ");  printf $3" "}' | head -c -1); do
    pactl set-sink-input-mute "$SINK" 0
  done
}

mute_sinks
sleep 0.5
mplayer -volume 100 "$MP3_PATH"
sleep 0.5
unmute_sinks