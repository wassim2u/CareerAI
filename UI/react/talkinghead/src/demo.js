
    import { TalkingHead } from "talkinghead";

    let head;

    document.addEventListener('DOMContentLoaded', async function(e) {

      // Instantiate the class
      // NOTE: Never put your API key in a client-side code unless you know
      //       that you are the only one to have access to that code!
      const nodeAvatar = document.getElementById('avatar');
      head = new TalkingHead( nodeAvatar, {
        ttsEndpoint: "https://eu-texttospeech.googleapis.com/v1beta1/text:synthesize",
        ttsApikey: "put-your-own-Google-TTS-API-key-here", // <- Change this
        lipsyncModules: ["en", "fi"],
        cameraView: "upper"
      });

      // Load and show the avatar
      const nodeLoading = document.getElementById('loading');
      try {
        nodeLoading.textContent = "Loading...";
        await head.showAvatar( {
          
          url: 'https://models.readyplayer.me/66b36c53183d0249c99881bf.glb?morphTargets=ARKit,Oculus+Visemes,mouthOpen,mouthSmile,eyesClosed,eyesLookUp,eyesLookDown&textureSizeLimit=1024&textureFormat=png',
          body: 'M',
          avatarMood: 'happy',
          ttsLang: "en-GB",
          ttsVoice: "en-GB-Standard-A",
          lipsyncLang: 'en'
        }, (ev) => {
          if ( ev.lengthComputable ) {
            let val = Math.min(100,Math.round(ev.loaded/ev.total * 100 ));
            nodeLoading.textContent = "Loading " + val + "%";
          }
        });
        nodeLoading.style.display = 'none';
      } catch (error) {
        console.log(error);
        nodeLoading.textContent = error.toString();
      }

      // Speak when clicked
      const nodeSpeak = document.getElementById('speak');
      nodeSpeak.addEventListener('click', function () {
        try {
          const text = document.getElementById('text').value;
          if ( text ) {
            head.speakText( text );
          }
        } catch (error) {
          console.log(error);
        }
      });

    });

 