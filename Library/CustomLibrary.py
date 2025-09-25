import requests
import random
import string
from datetime import datetime, timedelta


class CustomLibrary:

   def get_users_from_api(self):
       response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
       users = response.json()
       for user in users:
           first_name, last_name = self.handle_name_prefixes(user["name"])
           user["first_name"] = first_name
           user["last_name"] = last_name
           user["birthday"] = self.get_random_birthday()
           user["password"] = self.generate_password()
           user["address"]["stateAbbr"] = user["address"]["street"][0:2].upper()
       return users

   def get_random_birthday(self):
       return str(random.randint(1,12)).zfill(2) + str(random.randint(1,28)).zfill(2) + str(random.randint(1999,2006)).zfill(4)

   def generate_password(self, length=8):
       if length < 4:
           raise ValueError("Password length must be at least 4.")
       chars = string.ascii_letters + string.digits + "!@#$%"
       password = [
           random.choice(string.ascii_lowercase),
           random.choice(string.ascii_uppercase),
           random.choice(string.digits),
           random.choice("!@#$%")
       ]
       password += [random.choice(chars) for _ in range(length - 4)]
       random.shuffle(password)
       return ''.join(password)
