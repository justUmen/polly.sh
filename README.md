# polly.sh

Need an aws account with polly enabled.

## 1 - INSTALL AWS CLI (Linux)
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

## 2 - CONFIGURE (with IAM)

`aws configure`

User : your_username  
Access key ID : ...  
AWS Secret Access Key : ...  
Default region : us-east-1 (Not all regions have polly)  

## USAGE

`polly "hello world"`

`polly -v Gregory -l us "hello there"`

`polly -m -v Gregory -l us "don't play that audio, just create the file."`

### In zshrc or bashrc... (use your own script path of course)

```
function polly(){
	/home/umen/SyNc_linux/Scripts/Web/aws_polly/polly.sh "$@"
}
```

### Details

- Will create an audio file in : `$HOME/Audio/polly/$LANGUAGE/$VOICE/$NAME.mp3`. (Relaunching a tts for the same sentence will just read local audio file already created.)

- This is hardcoded in polly.sh, use `neural` engine on `us-east-1` : 

```
--region us-east-1 \
--engine neural \
```

### Options :

```
Valid options:
-l, --language [LANGUAGE_CODE]: Set the language code. (default : en-US)
-v, --voice [VOICE_ID]: Set the voice ID. (default : Joanna)
-m, --mute: Do not play audio, only create the audio file
--newscaster: Enable newscaster style for eligible voices.
--help: Display this help message.

Valid language codes and voices:
Language: ar-AE, Voices: Hala Zayd
Language: ja-JP, Voices: Kazuha Tomoko Takumi
Language: it-IT, Voices: Bianca Adriano
Language: nl-BE, Voices: Lisa
Language: yue-CN, Voices: Hiujin
Language: pt-BR, Voices: Vitoria Camila Thiago
Language: tr-TR, Voices: Burcu
Language: en-AU, Voices: Olivia
Language: fr-CA, Voices: Gabrielle Liam
Language: ko-KR, Voices: Seoyeon
Language: fr-FR, Voices: Lea Remi
Language: cmn-CN, Voices: Zhiyu
Language: de-DE, Voices: Vicki Daniel
Language: en-IN, Voices: Kajal
Language: en-US, Voices: Danielle Gregory Kevin Salli Matthew Kimberly Kendra Justin Joey Joanna Ivy Ruth Stephen
Language: en-IE, Voices: Niamh
Language: en-NZ, Voices: Aria
Language: de-AT, Voices: Hannah
Language: fi-FI, Voices: Suvi
Language: es-US, Voices: Lupe Pedro
Language: ca-ES, Voices: Arlet
Language: en-ZA, Voices: Ayanda
Language: es-MX, Voices: Mia Andres
Language: pl-PL, Voices: Ola
Language: pt-PT, Voices: Ines
Language: sv-SE, Voices: Elin
Language: da-DK, Voices: Sofie
Language: es-ES, Voices: Lucia Sergio
Language: en-GB, Voices: Amy Emma Brian Arthur
Language: fr-BE, Voices: Isabelle
Language: nb-NO, Voices: Ida
```
