import requests
import random
import string
from datetime import datetime, timedelta


class CustomLibrary:

   # === BASIC USERS (for Test 1) ===
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


   # === AUGMENTED USERS (for Test 2) ===
   def get_last_five_users(self):
       return self._fetch_users_slice(5, 10)


   def _fetch_users_slice(self, start, end):
       response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
       customers = response.json()


       augmented_users = []
       for idx, user in enumerate(customers[start:end], start=start + 1):
            name_parts = user["name"].split(" ")
       if len(name_parts) > 1:
           user["first_name"] = name_parts[0]
           user["last_name"] = " ".join(name_parts[1:])
       else:
           user["first_name"] = user["name"]
           user["last_name"] = ""
           user["birthday"] = self.get_random_birthday()
           user["password"] = self.generate_password()


           # Safe stateAbbr
           address_info = user["address"]
           street_char = str(address_info.get("street", "X"))[0].upper()
           suite_char = str(address_info.get("suite", "X"))[0].upper()
           city_char = str(address_info.get("city", "X"))[0].upper()
           user["address"]["stateAbbr"] = street_char + suite_char + city_char


           # Last seen (random in last 30 days)
           days_ago = random.randint(1, 30)
           last_seen_date = datetime.now() - timedelta(days=days_ago)
           user["last_seen"] = last_seen_date.strftime("%Y-%m-%d")


           # Orders (1–20)
           user["orders"] = random.randint(1, 20)


           # Total Spent
           if idx % 2 != 0:
               user["total_spent"] = random.choice([3600, 4500, 5200, 6000, 7500])
           else:
               user["total_spent"] = random.choice([0, 10, 50, 100, 200])
               augmented_users.append(user)


       return augmented_users


   # === Helpers ===
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


   def handle_name_prefixes(self, full_name):
       prefixes = ["Mr.", "Mrs.", "Ms.", "Dr."]
       name_parts = full_name.split(" ")
       if name_parts[0] in prefixes:
           first_name = name_parts[1]
           last_name = " ".join(name_parts[2:])
       else:
           first_name = name_parts[0]
           last_name = " ".join(name_parts[1:])
       return first_name, last_name
