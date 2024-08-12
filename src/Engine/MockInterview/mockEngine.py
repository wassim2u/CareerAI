from CV.cv import CVImage
from Model.models import GeminiModelWrapper
import logging


"""This is the main application for the mock interview stage."""
class MockInterviewEngine:
    # example_question1 = "Tell me a time when you faced the biggest challenges for your project, and what did you do to resolve them?"
    # example_question2 = "What are your biggest strengths?"
    # questions = [
    #     example_question1,example_question2
    # ]
  
    def __init__(self, CV, job_description, modelWrapper, number_of_questions=3) -> None:
        self.CV = CV
        self.job_description = job_description 
        self.modelWrapper = modelWrapper
        self.question_number = 0
        self.user_question_responses= [] 
        self.maximum_question_number = number_of_questions
        
        self.prev_GPT_response = None
        
    def request_user_answer(self):
        pass
    
    # TODO: Save Question & Answer responses.
    def follow_up_question(self, user_response):
        
        if self.modelWrapper.chat is None:
            logging.warning("Please properly start a new chat session with the LLM Model.")
            return None
        if self.question_number == self.maximum_question_number:
            pass
        else:
            follow_up_prompt = f"Given what you asked the candidate, this is their response: **{user_response}**. \
            "
            # Save (LLM, User) question response 
            self.user_question_responses.append([self.prev_GPT_response, user_response])
            
            # Respond to user with a question
            prompt = follow_up_prompt
            answer = self.modelWrapper.send_message(prompt)
            self.question_number+=1
            return answer
        
    def start_mock_interview(self):
        starting_prompt = "You will now play the role of an interviewer for the candidate who wants to apply to the job description listed here. You are the CEO of Google, Sundar Pichai. Act as if you are the interviewer for the company listed in the job description.  \
        At the end of the interview, you will generate a detailed feedback report for the user. The feedback should be consistent and logical. \
        The feedback should help the user assess their interview skills.  Now, please greet yourself in 1-3 sentences, and ask the first question.\
        Please refer the user's resume as well for the feedback and for the questions.  Do not output placeholder texts like [Candidate Name].  Refer to the candidate as \"Candidate\".\
        Here is the job description that the candidate wants to use: \n. \
        "
        
        
        
        if self.modelWrapper.chat is None:
            self.modelWrapper.start_new_chat()
        
        
        prompt = starting_prompt + self.job_description
        
        answer = self.modelWrapper.send_message(prompt)
        self.question_number +=1
        self.prev_GPT_response = answer.text
        return answer
        
        
        
    def end_interview_and_generate_feedback_report(self):
        if self.modelWrapper.chat is None:
            logging.warning("No session to end, the end_interview function may have been called incorrectly.")
            return None
        
        # end_prompt = f"This is the user's response to your final question for the interview: **{final_user_response}**. \
            
        end_prompt = "Given the list of answers to the questions you asked given by the user, please give an overall summary on how they answered each one. \
        Please also, after the feedback, provide some courses in Google and/or Coursera if needed to upgrade my skills."

        
        prompt = end_prompt
        final_answer = self.modelWrapper.send_message(prompt)

        return final_answer
    
    

        
    
    
    if __name__== "__main__":
        pass