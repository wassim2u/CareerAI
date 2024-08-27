# InVision | Google Gemini API Competition 

## Demo 
For a short demo of the submitted version to the Google Gemini API Competition, check out the link below
https://www.youtube.com/watch?v=ZfETT-D4Fpc


##

## Local Development

For the application to run, it needs to be launched locally for the time being. 
You need to launch three things:  Flutter Frontend, Flask Backend, and React Frontend.



## To run the Python app
Libraries: 
- Conda

  
Install the libraries using 
- `conda env create -n CareerAITest2 -f environment.yml`
- `pip install flask flask_restful flask_cors pandas`
- `pip install google-generativeai google-api-python-client  firebase_admin pillow`
- `pip install .` from the root page
- In the terminal, `export GOOGLE_API_KEY=Your_API_Key` to use the Gemini Functionality

Go to the api.py file in src/API/ and 
run `python api.py` to run the Flask server.

## To run the Flutter application
>> Go to the Folder UI/flutter_app
`flutter run -d chrome`
or
`flutter run --profile -d chrome` for a faster User experience.

For the submission of a demo resume, feel free to use my resume at the root of this page.

## To run the Avatar App 
>> Go to the Folder ./UI/react

- `npm install`
- `export REACT_APP_TTS_KEY=Your_API_Key
- `npm run`


Credits: 
- Ready Player Me (Avatar) - Developer License for Commercial Use
- https://github.com/met4citizen/TalkingHead

