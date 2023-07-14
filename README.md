# polly.sh

Need an aws account with polly enabled.

## 1 - INSTALL AWS CLI
sudo apt-get install awscli

## 2 - CONFIGURE (with IAM)

aws configure

User : your_username  
Access key ID : ...  
AWS Secret Access Key : ...  
Default region : us-east-1 (Not all regions have polly)  

## USAGE

`polly`

### in zshrc (use your own path of course)

    function polly(){
    	/home/umen/SyNc_linux/Scripts/Web/aws_polly/polly.sh "$@"
    }

### Options :

    Valid options:
    -l, --language [LANGUAGE_CODE]: Set the language code. (default : en-US)
    -v, --voice [VOICE_ID]: Set the voice ID. (default : Joanna)
    --newscaster: Enable newscaster style for eligible voices.
    --help: Display this help message.
    
    Valid language codes and voices:
    Language: ar-AE, Voices: Hala
    Language: nl-BE, Voices: Lisa
    Language: yue-CN, Voices: Hiujin
    Language: pt-BR, Voices: Camila Vitoria Thiago
    Language: en-AU, Voices: Olivia
    Language: fr-CA, Voices: Gabrielle Liam
    Language: fr-FR, Voices: Lea Remi
    Language: cmn-CN, Voices: Zhiyu
    Language: de-DE, Voices: Vicki DanielPE/9nqF/fXH54CJpH36zp4U+3kz4qh8T1ypXfibY
    Language: en-IN, Voices: Kajal
    Language: en-US, Voices: Joanna Ivy Kendra Kimberly Salli Joey Justin Kevin Matthew Ruth Stephen
    Language: en-IE, Voices: Niamh
    Language: en-NZ, Voices: Aria
    Language: fi-FI, Voices: Suvi
    Language: es-US, Voices: Lupe Pedro
    Language: ca-ES, Voices: Arlet
    Language: en-ZA, Voices: Ayanda
    Language: es-MX, Voices: Mia Andres
    Language: pt-PT, Voices: Ines
    Language: sv-SE, Voices: Elin
    Language: nl-NL, Voices: Laura
    Language: da-DK, Voices: Sofie
    Language: es-ES, Voices: Lucia Sergio
    Language: en-GB, Voices: Amy Emma Brian Arthur
