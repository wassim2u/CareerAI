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
        # if self.question_number == self.maximum_question_number:
        #     pass
        else:
            follow_up_prompt = f"Given what you asked the candidate, this is their response: **{user_response}**. Please follow up, make sure your questions are concise, as you are trying to emulate a real-life conversation. \
            "
            # Save (LLM, User) question response 
            self.user_question_responses.append([self.prev_GPT_response, user_response])
            print("I am here")
            # Respond to user with a question
            prompt = follow_up_prompt
            answer = self.modelWrapper.send_message(prompt)
            print(answer)
            self.question_number+=1
            return answer
        
    def start_mock_interview(self):
        starting_prompt = "You will now play the role of an interviewer for the candidate who wants to apply to the job description listed here. We are going to conduct a real-life like simulation of an interview, with you as the interviewer, and the candidate, and you will both be talking with each other. You are the CEO of Google, Sundar Pichai. Act as if you are the interviewer for the company listed in the job description.  \
        At the end of the interview, you will generate a detailed feedback report for the user. The feedback should be consistent and logical. \
        The feedback should help the user assess their interview skills.  Now, please greet yourself in 1-3 sentences, and ask the first question.\
        Please refer the user's resume as well for the feedback and for the questions.  Do not output placeholder texts like [Candidate Name].  Refer to the candidate as \"Candidate\".\
        Here is the job description that the candidate wants to use: \n. \
        "
        
        
        
        if self.modelWrapper.chat is None:
            self.modelWrapper.start_new_chat()
        
        
        prompt = starting_prompt + self.job_description
        
        
        tips = "\n Common Interview questions:1) What do you consider your greatest weakness?>> Purpose: assess self-awareness- Select a genuine weakness that is not critical for the job and show that I am actively working to improve it.- Frame the weakness in a way that also demonstrates my self-awareness and commitment to professional development. - Highlight a past weakness and the next steps I took to overcome and demonstrate my growth.- Start with “I am not sure about my greatest weakness, but I can talk about a weakness in the past and how I overcame it”.- A good “weakness” to mention: Sometimes I get caught up in the details, but this has led me to realign my workflow regularly to ensure that I move on to the next task at an appropriate speed.2) What sets you apart from other candidates?- Use this question to highlight my top 5 strengths directly related to the role, from the job description.- Look to see which strengths they are looking for, and give examples of me possessing these traits.3) Tell me a time you could not meet a goal / deadline and how you handled it.- Explain how I react to situations that don’t go as planned.- Explain a time when things did not go as planned, the steps I took to manage and fix the situation, and lessons learned so it does not happen again.- Be honest about the circumstances, showing accountability without making excuses.4) Tell me a time you made a mistake. How did you handle it?- Illustrate how I overcome obstacles.- Acknowledge the error quickly and outline the steps taken to rectify the situation.- Explain a time I made a mistake and highlight the things I did to fix the situation and lessons I have learned so the mistake does not happen again, but also how it led to personal and professional growth.5) Why do you want to work for us / for the company?- Research the company and talk about the things you love about it.- Mention why I like the position itself and why this is a great fit.- Cite specific aspects of the company’s culture, mission, or projects that resonate with my own goals and interests. - Demonstrate my understanding of the company’s industry standing and express enthusiasm for contributing to its success. 6) What is your greatest strength?- Identify strengths with clear examples that demonstrate success in previous roles.- Look at the job description and only talk about strengths directly related to the role I am interviewing for. Align these strengths with the core requirements of the position I am applying for. - Show why I am a great fit for the role and explain how I have the skills that this job demands. 7) Tell me about some of the most difficult problems you worked on and how you solved them.- Show my problem-solving skills and what is my thought process.- I want the interviewer to feel confident in my ability to solve problems and create solutions. 8) Describe a time when you successfully balance several competing priorities.- Elaborate on my multitasking and organisational skills.- Explain how I organise your work and schedule your time.- Use this to show that I get things done!9) Why do you want to leave your current position?- Thank my current role for the things I have learned but explain why I am interested in the new role.- Explain what I enjoy most about the company and the position I am interviewing for. 10) What have been your most significant accomplishments?- Discuss problems that I solved [that can be related the position I am interviewing for]. - Talk about my top achievements that are related to this role, so the interviewer understands the value I will bring to the company and role. 11) Tell me about yourself. >> Purpose: Gauge communication skills- Don’t recite my resume. Tell a story and hook the interviewer with a unique opening, by sharing a defining moment, then tie this to my passion for the role.Example: As a kid, I started a lemonade stand and loved the trill of making a sale. That spark led me to study. Marketing and land my dream role XXXX. There I created a viral campaign that doubled sales for a struggling client, proving I can turn creativity into results. Now I am exciting to bring that same passion and impact to this role.- Summarise my professional background with a focus on experiences relevant to the role.- Highlight personal qualities or achievements that align with the company’s values and mission. 12) What can you bring to the company?- Share specific examples of my contributions to past roles that had a positive impact.-Discuss my approach to problem-solving and innovation that will benefit the company’s objectives.13) Tell me about a challenge you have faced and how you dealt with it.- Describe the situation succinctly, focusing on the actions I took to overcome the challenge. - Conclude with the successful outcome of what I learned, emphasising problem-solving abilities.14) How do you deal with difficult people?- Emphasise empathy and active listening skills to understand their perspective and find common ground.- Mention specific strategies for maintaining professionalism and collaboration despite differences.15) Why do you want this job?- Connect the job responsibilities with my skills and express how this role fits into my career path.- Discuss my passion for the work and the impact I hope to have within the company.16) Why should we hire you?- Point out how my unique skill set, experiences, and achievements will bring value to the team and company. - Explain how my career goals align with the company’s direction and needs. 17) Tell me about a time when your work was criticised and you handled it.- Discuss the critique with an open mind, focusing on the constructive elements. - Share the specific changes I implemented because of the feedback and the positive outcomes that followed. 18) Where do you see yourself in 5 years?>> Purpose: understand career ambitions- Align goals with the company’s future.- If I have clear career goals, discuss them. Otherwise highlight the skills that this position offers and that I would love to develop.19) Can you explain this gap in your employment?- Be upfront but brief. - Pivot to any skills or experiences I gained during this gap.- Offer positive and constructive explanations.- Show excitement about returning to work.Example: After my department was restructured, I decided to take some time to focus on my family and recharge. But I also used that period to sharpen my skills. I took online courses in XXX. I took on some freelance projects to keep my industry knowledge fresh. Now, I am excited to dive back in and bring new energy to a full time role.20) How do you handle stress and pressure?- Discuss strategies for managing stress.21) How do you prioritise your work?>> Purpose: assess organisational skills- Explain my approach to task management.22) What are your salary expectations?- Show that I have done my homework, give a range and not a number. Example: I have researched salaries for similar roles, and I am looking for something in the £X to £X range. I am confident that if I am the right fit for this position, we will be able to a compensation agreement that works well for both of us. For me the most important thing is finding an opportunity where I can make a real impact and grow with a great team.23) What motivates you?- Answer this by focusing on the work itself: I like challenging myself, growing, and gaining new skills.24) Are you comfortable working independently?- Explain that I love to take initiative, and can handle all the tasks in the job listing effectively without a need of constant supervision. Of course I do need the right amount of communication, particularly when tackling the initial learning curve.25) How do you define success?26) How do I stay organised?- Explain general tips for keeping on track, from task grouping to time management. Also specify tools / software used for this.27) Can you describe your work ethic?- Common answers: dedication, reliability, enthusiasm, passion, detail-oriented, integrity… But pick few that describes me and are more personal and present them well.28) Can you describe your approach to continuous learning and professional development?- Describe what you do in your free time to upskill."
        prompt = prompt + "\n Here are some questions you can use. Some of the questions include tips and what the recruiter is looking for. Use these to generate the answers."
        prompt = prompt  + tips
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