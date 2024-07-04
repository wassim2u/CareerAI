

import pathlib
import google.generativeai as genai
import os
from abc import ABC, abstractmethod
import logging
from CV.cv import CVImage

class LLMModelWrapper(ABC):
    
    
    
    def __init__(self, model_name, model) -> None:
        self.model_name = model_name
        self.model = model
        
    
    
    def get_model(self):
        return self.model 

    
    
    def get_model_name(self):
        return self.model_name
    
    
    # def prompt():
    #     prompt = "My name is {}. I "
    
    @abstractmethod
    def get_model_response(self, question, stream=False):
        pass
    
    


class GeminiModelWrapper(LLMModelWrapper):
    # gemini-1.5-flash
    def __init__(self, gemini_model_type='gemini-1.5-flash', history= []) -> None:
        # Initialise the Gemini Model - Pass the Google API Key
        GOOGLE_API_KEY = os.getenv('GOOGLE_API_KEY')
        genai.configure(api_key=GOOGLE_API_KEY)
        model = genai.GenerativeModel(gemini_model_type)
        super().__init__(model_name= gemini_model_type, model=model)

        self.chat = None
        self.history = None    
    def get_model_response(self,question, stream=False):
        response = self.chat.send_message(question, stream=stream)
        return response
    
    # Initialise a new chat
    def start_new_chat(self,history=[]):
        logging.info("Starting a new chat session...")
        self.chat = self.model.start_chat(history=history)
        self.history = history
        
        
    def send_message(self,full_prompt):
        if self.chat is None:
            self.start_new_chat()
        logging.info("Gemini Text Prompt: " + full_prompt)
        response = self.chat.send_message(
            [full_prompt]
        )
        logging.info("Gemini Response: " + str(response))

        return response
    
    def send_message_w_attachment(self, full_prompt, cookie_picture):
        if self.chat is None:
            self.start_new_chat()
        logging.info("Gemini Text Prompt w/ Attached Photo: " + full_prompt)
        response = chat.send_message(
            [full_prompt, cookie_picture]
        )
        logging.info("Gemini Response: " + str(response))

        return response
      
    

    def get_resume_feedback(self,CV,job_link):
        if self.chat is None:
            self.start_new_chat()
            
        
        
        cookie_picture = {
            'mime_type': CV.media_type,
            'data': pathlib.Path(CV.image_path).read_bytes()
        }
        
        
        introduction_prompt = "I would like some help with job application. Please find my resume attached. \
    Here is the job description I want to apply to. Please give me detailed feedback, and tell me if I fit the role. Please ask me three questions you would like me to answer if you would like more information before giving a feedback.\
    Please also, after the feedback, provide some courses in Google and/or Coursera if needed to upgrade my skills. Could you also provide some table structured information along with the feedback to have data visualisation for me based on the feedback, job description, and resume? For example, i want some information that can showcase my : "

        # extra_prompt = "Please note the number of years of experience, and the seniority of the role. Indicate whether i need more experience to be able to fit within the role. Watch out for unconsious bias."
        # question_prompt = "" #Additional answers to questions asked by Gemini.
        
        prompt = introduction_prompt +  job_link

        response = chat.send_message(
            [prompt, cookie_picture]
        )
        
        return response


class AIEngine:
    def __init__(self, model, CV, Job) -> None:
        self.model = model
        self.CV = CV
        self.Job = Job
        
        
        
    
        
    
        
if __name__ == "__main__":
    gemini_model_type = 'gemini-1.5-flash'
    GOOGLE_API_KEY = os.getenv('GOOGLE_API_KEY')
    genai.configure(api_key=GOOGLE_API_KEY)
    model = genai.GenerativeModel(gemini_model_type)
    chat = model.start_chat(history=[])

    geminiWrapper = GeminiModelWrapper(gemini_model_type=gemini_model_type, history=[])
    
    
    CVObject = CVImage(image_path="/Users/wassim/Documents/Projects/LevelUp/Resume.jpg", media_type="image/jpeg")
    job_text_link = "https://www.google.com/about/careers/applications/jobs/results/142343026188919494-senior-research-scientist-google-research"

    response = geminiWrapper.get_resume_feedback(CV=CVObject, job_link=job_text_link) 
    print(response.text)      

        

    
    

    
    


