import logo from './logo.svg';
import './App.css';
import ReactDOM from 'react-dom';
import React, { Component } from "react";
import { useEffect, useRef } from "react";
import * as THREE from 'three';

import { TalkingHead } from "./talkinghead.mjs";
import { Helmet } from "react-helmet";
import * as EN from './lipsync-en.js';
import Three from 'three'
import {useStream} from 'react-fetch-streams';

import { useState } from 'react';
// import { TalkingHead, speakText } from "./talkinghead.mjs";


async function speak(head, text){
    head.speakText(text);
  
  }

function SSEComponent(head) {
  // State to store the incoming data
  const [data, setData] = useState('');

  useEffect(() => {
    // Creates a new EventSource object to listen to events at the specified URL
    const eventSource = new EventSource('http://127.0.0.1:5000/events');
    let timeout;

    // Function to reset a timeout to close the event source connection after a period of inactivity
    const resetTimeout = () => {
      clearTimeout(timeout); // Clears the existing timeout
      // Sets a new timeout to close the event source connection after 10000ms (10 seconds) of inactivity
      timeout = setTimeout(() => eventSource.close(), 10000); 
    };

    // Event handler for receiving messages
    eventSource.onmessage = function(event) {
      resetTimeout(); // Resets the timeout on each message received to keep the connection open
      // Parses the incoming message and updates the component's state with the new data
      const receivedData = JSON.parse(event.data).data;
      // setData(prevData => prevData + receivedData);
      console.log("Recieved from LLM Backend: " + receivedData);
      speak(head, receivedData);

    };
    resetTimeout(); // Initialize the timeout when the component mounts

    // Cleanup function to clear the timeout and close the event source connection when the component unmounts
    return () => {
      clearTimeout(timeout);
      eventSource.close();
    };
  }, []); // Empty dependency array means this effect runs only once when the component mounts

  // Renders the accumulated data in a div
  return <div>{data}</div>;
}




// require('./lipsync-fi.mjs');
// require('./lipsync-lt.mjs');
// const MyComponent = props => {
//   const [data, setData] = useState({});
//   const onNext = useCallback(async res => {
//       const data = await res.json();
//       setData(data);
//   }, [setData]);
//   useStream('http://myserver.io/stream', {onNext});

//   return (
//       <React.Fragment>
//           {data.myProp}
//       </React.Fragment>
//   );
// };

// function App() {
//   return (
//     <div className="App">
//       <div> Hello </div>

//     </div>
//   );
// }

let head;




/** @import { Avatar } from "./talkinghead.mjs" */
/**
 * @param {Object} Avatar
 */
async function run(refContainer) {
  await import("./" + 'lipsync-en' + '.js');

  // var renderer = new THREE.WebGLRenderer();
  
  // renderer.setSize(window.innerWidth, window.innerHeight);
  // document.body.appendChild( renderer.domElement );
  // // use ref as a mount point of the Three.js scene instead of the document.body
  // refContainer.current && refContainer.current.appendChild(renderer.domElement);
  

  console.log('document was not ready, place code here');
  
  // Instantiate the class
  // NOTE: Never put your API key in a client-side code unless you know
  //       that you are the only one to have access to that code!
  const nodeAvatar = document.getElementById('avatar');
  head = new TalkingHead(nodeAvatar, {
    ttsEndpoint: "https://eu-texttospeech.googleapis.com/v1beta1/text:synthesize",
    ttsApikey: process.env.TTS_KEY, // <- Change this
    lipsyncModules: ["en"],
    cameraView: "upper"
  });


  // Load and show the avatar
  const nodeLoading = document.getElementById('loading');
  try {
    nodeLoading.textContent = "Loading...";
    await head.showAvatar({

      url: 'https://models.readyplayer.me/66b36c53183d0249c99881bf.glb?morphTargets=ARKit,Oculus+Visemes,mouthOpen,mouthSmile,eyesClosed,eyesLookUp,eyesLookDown&textureSizeLimit=1024&textureFormat=png',
      body: 'M',
      avatarMood: 'happy',
      ttsLang: "en-IN",
      ttsVoice: "en-IN-Neural2-C",
      lipsyncLang: 'en'
    }, (ev) => {
      if (ev.lengthComputable) {
        let val = Math.min(100, Math.round(ev.loaded / ev.total * 100));
        nodeLoading.textContent = "Loading " + val + "%";
      }
    });
    nodeLoading.style.display = 'none';
  } catch (error) {
    console.log(error);
    nodeLoading.textContent = error.toString();
  }

      // Creates a new EventSource object to listen to events at the specified URL
      
      const eventSource = new EventSource('http://127.0.0.1:5000/events');
      let timeout;
  
      // Function to reset a timeout to close the event source connection after a period of inactivity
      const resetTimeout = () => {
        clearTimeout(timeout); // Clears the existing timeout
        // Sets a new timeout to close the event source connection after 10000ms (10 seconds) of inactivity
        timeout = setTimeout(() => eventSource.close(), 10000); 
      };
  
      // Event handler for receiving messages
      eventSource.onmessage = function(event) {
        resetTimeout(); // Resets the timeout on each message received to keep the connection open
        // Parses the incoming message and updates the component's state with the new data
        const receivedData = JSON.parse(event.data).data;
        // setData(prevData => prevData + receivedData);
        console.log("Recieved from LLM Backend: " + receivedData);
        speak(head, receivedData);
  
      };
      resetTimeout(); // Initialize the timeout when the component mounts
  
      // Cleanup function to clear the timeout and close the event source connection when the component unmounts
      return () => {
        clearTimeout(timeout);
        eventSource.close();
      };
  // try {
  //   if ( text ) {
  //     head.speakText( text );
  //   }
  // } catch (error) {
  //   console.log(error);
  // }
  console.log(nodeAvatar)


}

function App() {
  console.log('ok');

  const refContainer = useRef(null);

  console.log('ok3');
  var inCloudFlare = true;

    if (global?.window) {
      console.log("hello00");

    window.addEventListener('DOMContentLoaded', run(refContainer), false);
    }
 

  // document.addEventListener('DOMContentLoaded', );


  // return (
  //   <div ref={refContainer}></div>

  // );

  
  return (
    <div>

    
      <div id="avatar-container" ref={refContainer}>

      <div id="avatar">

      </div>
      </div>
      
      <div id="loading"> </div>
      {/* <SSEComponent head={head} /> */}
    </div>


  

  )
}


export default App;
