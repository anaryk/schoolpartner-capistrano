## Usage

To use this project, follow these steps:

1. Clone the repository
2. Run docker compose ```docker compose up -d --build --force-recreate```
3. (Optional) Get public SSH key and import to server ```docker compose logs```
4. Exec into deployer pod and run cap commands using this command ```docker compose exec deployer /bin/sh ```


This image is optimised for arm,linux,windows


