import time
from flask import Flask, render_template, jsonify, Response
from flask_restful import Resource, Api, reqparse, request
from flask_cors import CORS, cross_origin

import pandas as pd
import ast
import os
import google.cloud
import json

from Model.models import GeminiModelWrapper
import google.generativeai as genai

from CV.cv import CVImage

import firebase_admin
from firebase_admin import credentials, firestore, storage

from Engine.MockInterview.mockEngine import MockInterviewEngine

APP_ROOT = os.path.dirname(os.path.abspath(__file__))
GOOGLE_API_KEY = os.getenv('GOOGLE_API_KEY')

app = Flask(__name__)
api = Api(app)
CORS(app)



# TODO: Make this more scalable
AI_Responses = {}
num_responses = 0
def generate_events():
    """Generator function to yield events from the LLM response."""
    while True:
        # TODO: Make this more scalable
        global num_responses
        
        if AI_Responses.get("guest") is not None and  len(AI_Responses["guest"]) > num_responses:        
            # print("break")
            # print(len(AI_Responses["guest"]))
            # print(num_responses)
            num_responses+=1    
            # print(AI_Responses["guest"][-1])
            json_data =  json.dumps({'data': AI_Responses["guest"][-1].replace("\"", "")}) 

            yield f"event:message\ndata: {json_data}\n\n"
        # await time.sleep(1)
        time.sleep(5)


    # yield "event: end\ndata: stream\n\n"


# # TODO: Make this more scalable
# AI_Responses = {}
# num_responses = 0
# def generate_events():
#     """Generator function to yield events from the LLM response."""
#     # TODO: Make this more scalable
#     response = "This is a test"
#     print("activated")
#     time.sleep(1)
#     global num_responses
#     # json_data =  json.dumps({'data': AI_Responses["guest"][-1].replace("\"", "")}) 
#     json_data =  json.dumps({'data': response}) 

#     yield f"event:message\ndata: {json_data}\n\n"

#     # yield "event: end\ndata: stream\n\n"




cred = credentials.Certificate("/Users/wassim/Documents/Projects/LevelUp/Secrets/gen-lang-client-0071363946-firebase-adminsdk-nsnfm-f7238ff585.json")
firebase_admin.initialize_app(cred,   {
    'storageBucket': 'gs://gen-lang-client-0071363946.appspot.com'
})
bucket = storage.bucket()
    

class LLMResponse(Resource):
    behavourialEngineSessions = {}
    
    def get(self, username, feedback_type, initialise, user_response):

        
        # response = self.quick_model(CV_LINK_TEMP, JOB_DESCRIPTION_TEMP)
        # print(response)
        try: 
                
                
            print("Username: " + username)
            print("Feedback Type: " + feedback_type)
            job_description, cv_link= self.query_db(username)

            
            if feedback_type == "quick":
                model_response = self.quick_model(cv_link= cv_link, job_description=job_description)
                print(model_response)
                return jsonify(model_response.text)
            elif feedback_type == "behavourial":
                # Initialise
                if initialise == 1:
                    
                    # behavourialEngine = self.behavourialEngineSessions.get(username) 
                    model_type= 'gemini-1.5-flash'
                    geminiWrapper = GeminiModelWrapper(gemini_model_type=model_type, history=[])
                    
                    behavourialEngine = MockInterviewEngine(CV= cv_link, job_description= job_description, modelWrapper=geminiWrapper)
                    self.behavourialEngineSessions[username] = behavourialEngine
                    global AI_Responses , num_responses
                    AI_Responses[username] = []
                    num_responses = 0
                    model_response = behavourialEngine.start_mock_interview()
                    AI_Responses[username].append(model_response.text)
                    return  jsonify(model_response.text)
                # Finish Mock Interview
                elif initialise== 2:
                    behavourialEngine = self.behavourialEngineSessions[username]
                    model_response = behavourialEngine.end_interview_and_generate_feedback_report()
                    return  jsonify(model_response.text)
                # Continue:
                else:
                    behavourialEngine = self.behavourialEngineSessions[username]
                    model_response = behavourialEngine.follow_up_question(user_response)
                    
                    print(model_response.text)
                    AI_Responses[username].append(model_response.text)
                    return  jsonify(model_response.text)

                
            else: 
                print("Not Implemented this feedback type yet!")
        except Exception as e:
            print(e)
            return jsonify("Could you repeat your question please?")
            
        
    
    def quick_model(self,cv_link,job_description,  model_type= 'gemini-1.5-flash'):
        gemini_model_type = model_type
        genai.configure(api_key=GOOGLE_API_KEY)
        geminiWrapper = GeminiModelWrapper(gemini_model_type=gemini_model_type, history=[])
        
        
        CVObject = CVImage(image_path=cv_link, media_type="image/jpeg")
        print(CVObject.image_path)
        response = geminiWrapper.get_resume_feedback(CV=CVObject, job_link=job_description) 
        
        return response             
    def query_db(self, userID):
        db = firestore.client()
        job_description, cv_link = self.retrieve_uploaded_job_description_and_cv(db, userID)
        return job_description, cv_link
            
    def retrieve_uploaded_job_description_and_cv(self,db, userID):
        
       
        # TODO: Change "guest" to userID login from the authentication service
        document_ref = db.collection("job_descriptions").document("guest")       
        
        
        try:
            doc = document_ref.get()
            if doc.exists:
                print(f"Job Description Document data: {doc.to_dict()}")
            else:
                print("No such document! Has the user uploaded their job description successfully?")
        except google.cloud.exceptions.NotFound:
            print(u'Missing data when retrieving the database')
            
        doc = doc.to_dict()
        return doc["job_description"], doc["cv_link"]



        

     



api.add_resource(LLMResponse, '/<string:username>/<string:feedback_type>/<int:initialise>/<string:user_response>')

# Defines a route in the Flask app that clients can connect to for receiving streamed events
@app.route('/events')
@cross_origin(supports_credentials=True)
def sse_request():
    """Route to handle SSE (Server-Sent Events) requests."""
    # Returns a streaming response that yields data from the `generate_events` generator function
    
    return Response(generate_events(), content_type='text/event-stream')

if __name__=="__main__":
    app.run(debug=True)




