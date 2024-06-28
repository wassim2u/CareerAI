

class CVImage:
    image_path = ""
    
    
    def __init__(self, image_path, media_type="image/jpeg") -> None:
        self.image_path = image_path
        self.media_type = media_type
        
    def setNewCV(self, image_path, media_type) -> None:
        self.image_path = image_path
        self.media_type = media_type

        

    