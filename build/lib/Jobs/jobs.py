

class JobPosition:
    
    def __init__(self, title, description, location, job_link) -> None:
        self.title = title
        self.description = description
        self.location = location
        self.job_link = job_link



    def getTitle(self):
        return self.title

    
    def getJobDescription(self):
        return self.description
    
    
    def getLocation(self):
        return self.location
    
    
    def getJobLink(self):
        return self.job_link