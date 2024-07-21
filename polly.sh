#!/bin/bash
# Array of valid languages and their corresponding voices
VALID_LANGUAGES=(
  "ar-AE" "nl-BE" "ca-ES" "yue-CN" "cmn-CN" "da-DK" "nl-NL" "en-AU" "en-GB" "en-IN" "en-IE" "en-NZ" "en-ZA" "en-US"
  "fi-FI" "fr-CA" "fr-FR" "de-DE" "de-AT" "hi-IN" "it-IT" "ja-JP" "ko-KR" "nb-NO" "pl-PL" "pt-BR" "pt-PT" "es-ES" "es-MX" "es-US" "sv-SE"
  "ar" "ae" "nl" "ca" "cat" "yue" "cmn" "da" "au" "gb" "nz" "sa" "za" "us" "fi" "fr" "de" "at" "hi" "it" "jp" "ko" "nb" "pl" "br" "pt" "es" "es2" "mx" "sv" "se" 
  "ie" "ir" "en2" "en3" "en4" "en5" "en6" "de2" "fr2" "pt2"
)

declare -A LANGUAGE_VOICES=(
    ["ar-AE"]="Hala Zayd"
    ["ca-ES"]="Arlet"
    ["cmn-CN"]="Zhiyu"
    ["da-DK"]="Sofie"
    ["de-AT"]="Hannah"
    ["de-DE"]="Vicki Daniel"
    ["en-AU"]="Olivia"
    ["en-GB"]="Amy Emma Brian Arthur"
    ["en-IE"]="Niamh"
    ["en-IN"]="Kajal"
    ["en-NZ"]="Aria"
    ["en-US"]="Danielle Gregory Kevin Salli Matthew Kimberly Kendra Justin Joey Joanna Ivy Ruth Stephen"
    ["en-ZA"]="Ayanda"
    ["es-ES"]="Lucia Sergio"
    ["es-MX"]="Mia Andres"
    ["es-US"]="Lupe Pedro"
    ["fi-FI"]="Suvi"
    ["fr-BE"]="Isabelle"
    ["fr-CA"]="Gabrielle Liam"
    ["fr-FR"]="Lea Remi"
    ["it-IT"]="Bianca Adriano"
    ["ja-JP"]="Kazuha Tomoko Takumi"
    ["ko-KR"]="Seoyeon"
    ["nl-BE"]="Lisa"
    ["nb-NO"]="Ida"
    ["pl-PL"]="Ola"
    ["pt-BR"]="Vitoria Camila Thiago"
    ["pt-PT"]="Ines"
    ["sv-SE"]="Elin"
    ["tr-TR"]="Burcu"
    ["yue-CN"]="Hiujin"
)

# Function to display valid options and values
function display_help() {
  echo "Valid options:"
  echo "-l, --language [LANGUAGE_CODE]: Set the language code. (default : en-US)"
  echo "-v, --voice [VOICE_ID]: Set the voice ID. (default : Joanna)"
  echo "-m, --mute: Do not play audio, only create the audio file"
  echo "--newscaster: Enable newscaster style for eligible voices."
  echo "--help: Display this help message."
  echo ""
  echo "Valid language codes and voices:"
  for language in "${!LANGUAGE_VOICES[@]}"; do
    voices="${LANGUAGE_VOICES[$language]}"
    echo "Language: $language, Voices: $voices"
  done
  echo ""
  echo "Abrev : English : en us au gb nz sa za ie ir en2 en3 en4 en5 en6"
  echo "etc..."
}

# Function to convert the language code to the appropriate format
function convert_language_code() {
  local language=$1
  case $language in
  #Manual changes
  "en") echo "en-GB" ;; # English default is British (Amy default voice)
  # English : au gb nz sa za us ie ir en2 en3 en4 en5 en6
  "en3") echo "en-IN" ;;  # English (Indian)
  "au") echo "en-AU" ;;   # English (Australian)
  "en4") echo "en-AU" ;;   # English (Australian)
  "gb") echo "en-GB" ;;   # English (British)
  "nz") echo "en-NZ" ;;   # English (New Zealand)
  "en5") echo "en-NZ" ;;   # English (New Zealand)
  "sa") echo "en-ZA" ;;   # English (South African)
  "za") echo "en-ZA" ;;   # English (South African)
  "en5") echo "en-ZA" ;;   # English (South African)
  "us") echo "en-US" ;;   # English (US)
  "en2") echo "en-US" ;;   # English (US)
  "ie") echo "en-IE" ;;  # English (Irish)
  "ir") echo "en-IE" ;;  # English (Irish)
  "en6") echo "en-IE" ;;  # English (Irish)
  # French
  "fr") echo "fr-FR" ;;   # French
  "fr2") echo "fr-CA" ;;   # French (Canadian)
  "ca") echo "fr-CA" ;;   # French (Canadian)
  # Spanish  
  "es") echo "es-ES" ;;   # Spanish (European)
  "es2") echo "es-US" ;;  # Spanish (US)
  "mx") echo "es-MX" ;;   # Spanish (Mexican)
  # Portuguese
  "pt") echo "pt-PT" ;;   # Portuguese (European)
  "pt2") echo "pt-BR" ;;   # Portuguese (Brazilian)
  "br") echo "pt-BR" ;;   # Portuguese (Brazilian)
  # German
  "de") echo "de-DE" ;;   # German
  "de2") echo "de-AT" ;;   # German (Austrian)
  "at") echo "de-AT" ;;   # German (Austrian)
  # Other
  "ar") echo "ar-AE" ;;   # Arabic (Gulf)
  "ae") echo "ar-AE" ;;   # Arabic (Gulf)
  "nl") echo "nl-BE" ;;   # Belgian Dutch (Flemish)
  "cat") echo "ca-ES" ;;  # Catalan
  "yue") echo "yue-CN" ;; # Chinese (Cantonese)
  "cmn") echo "cmn-CN" ;; # Chinese (Mandarin)
  "da") echo "da-DK" ;;   # Danish
  "nl") echo "nl-NL" ;;   # Dutch
  "fi") echo "fi-FI" ;;   # Finnish
  "in") echo "hi-IN" ;;   # Hindi
  "it") echo "it-IT" ;;   # Italian
  "ja") echo "ja-JP" ;;   # Japanese
  "jp") echo "ja-JP" ;;   # Japanese
  "ko") echo "ko-KR" ;;   # Korean
  "kr") echo "ko-KR" ;;   # Korean
  "nb") echo "nb-NO" ;;   # Norwegian
  "no") echo "nb-NO" ;;   # Norwegian
  "pl") echo "pl-PL" ;;   # Polish
  "sv") echo "sv-SE" ;;   # Swedish
  "se") echo "sv-SE" ;;   # Swedish
  "tr") echo "tr-TR" ;;  # Turkish
  *) echo "$language" ;;
  esac
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
# LANGUAGE="fr-FR" #default to french (Lea)
LANGUAGE="en-GB" #default to british (Amy)
NEWSCASTER_STYLE=false
MUTE=false

# Check if no arguments are provided or if the --help option is used
if [[ $# -eq 0 ]] || [[ "$1" == "--help" ]]; then
  display_help
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case $1 in
  -v | --voice)
    shift
    VOICE=$1
    ;;
  -l | --language)
    shift
    LANGUAGE=$1
    ;;
  -n | --newscaster)
    NEWSCASTER_STYLE=true
    ;;
  -m | --mute)
    MUTE=true
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

# Convert the language code to the appropriate format
LANGUAGE_GIVEN=$LANGUAGE
LANGUAGE=$(convert_language_code "$LANGUAGE")

# Check if the provided language is valid
if ! [[ " ${VALID_LANGUAGES[@]} " =~ " $LANGUAGE " ]]; then
  echo "Invalid language. Valid languages are: ${VALID_LANGUAGES[*]}"
  exit 1
fi

# If no voice is provided, use the default voice for the language (first of the list)
if [[ -z "$VOICE" ]]; then
  VOICE=$(echo "${LANGUAGE_VOICES[$LANGUAGE]}" | awk '{print $1}')
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
echo "_ LANGUAGE_GIVEN = $LANGUAGE_GIVEN _"
echo "_ LANGUAGE = $LANGUAGE _"
echo "_ VOICE = $VOICE _"
echo "_ TEXT = $TEXT _"
echo "_ TEXT_SSML = $TEXT_SSML _"
echo "_ NAME = $NAME _"
echo "_ MP3_PATH = $MP3_PATH _"
FOLDER_PATH=$(dirname "$MP3_PATH")
echo "_ FOLDER_PATH = $FOLDER_PATH _"

# Check if the provided voice is valid for the given language
if ! is_valid_voice "$VOICE" "$LANGUAGE"; then
  echo "Invalid voice for the selected language. Valid voices for $LANGUAGE are: ${LANGUAGE_VOICES[$LANGUAGE]}"
  exit 1
fi

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
    "$MP3_PATH" >/dev/null
  echo "Audio file was created (\"$MP3_PATH\")"
else
  echo "Audio file already exist (\"$MP3_PATH\")"
fi
# exit
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

echo "MUTE = $MUTE"
if $MUTE; then
  ln -s -f "$MP3_PATH" "/tmp/last_polly.mp3"
  exit 0
fi
mute_sinks
sleep 0.5
mplayer -volume 100 "$MP3_PATH"
sleep 0.5
unmute_sinks
