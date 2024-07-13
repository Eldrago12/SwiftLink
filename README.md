# SwiftLink

SwiftLink is a serverless URL shortener service built using AWS Lambda, API Gateway, DynamoDB, AWS Secrets Manager, Route53, AWS Certificate Manager, and JWT Authentication using Firebase. The service provides endpoints for creating, retrieving, and deleting shortened URLs. Additionally, an iOS app built with Swift and SwiftUI interacts with the API to manage URLs.

## Screenshots


<img width="370" alt="Screenshot 2024-07-14 at 12 47 39 AM" src="https://github.com/user-attachments/assets/0a4a492a-2731-490d-9b6f-26a43c174d6c">

<img width="382" alt="Create" src="https://github.com/user-attachments/assets/e8523e69-0ee7-43ba-b2ae-0ccf69db709a">

<img width="382" alt="Get" src="https://github.com/user-attachments/assets/17879803-2fcd-4855-9e05-cac16d6f3435">

<img width="378" alt="Delete" src="https://github.com/user-attachments/assets/41260547-c79b-452e-a882-578c7b6295fc">


## Prerequisites

To set up and run this project locally, you will need the following:

- **Python:** Ensure Python is installed on your machine.
  
- **AWS CLI:** Install the AWS Command Line Interface.
  ```bash
  pip install awscli
  ```
  
- **AWS SAM CLI:** Install the AWS Serverless Application Model CLI.
  ```bash
  pip install aws-sam-cli
  ```
  
- **Docker:** Install Docker to build and run the API locally.


## Setup and Build

1. **Clone the repository:**
    ```bash
    git clone https://github.com/Eldrago12/SwiftLink.git
    cd SwiftLink/src
    ```

2. **Install AWS SAM CLI (if not already installed):**
   ```bash
   pip install aws-sam-cli
   ```

3. **Build the CloudFormation template:**
   ```bash
   sam build
   ```

4. **Start a local development server:**
   ```bash
   sam local start-api
   ```

5. **Deploy the API to AWS:**
   ```bash
   sam deploy --guided
   ```

**Set up parameters in the `template.yaml` file located in the `root/` directory.**


## API Endpoints

- **Sign Up:**
  ```bash
  POST https://api.opsorbit.me/signup
  ```
  
  - **Request Body:**
    ```bash
    {
      "email": "string",
      "password": "string"
    }
    ```

- **Login:**
  ```bash
  POST https://api.opsorbit.me/login
  ```
  
  - **Request Body:**
    ```bash
    {
      "email": "string",
      "password": "string"
    }
    ```

  - **Response:**
    ```bash
    {
      "idToken": "string",
      "refreshToken": "string",
      "expiresIn": "string"
    }
    ```

- **Create URL:**
  ```bash
  POST https://api.opsorbit.me/createurl
  ```
  
  - **Request Header:**
    ```bash
    Authorization: Bearer <idToken>
    ```
    - **Request Body:**
      ```bash
      {
        "originalUrl": "string"
      }
    - **Response:**
      ```bash
      {
        "shortUrl": "string"
      }

- **Get URLs:**
  ```bash
  GET https://api.opsorbit.me/geturl
  ```
  - **Request Header:**
    ```bash
    Authorization: Bearer <idToken>
    ```

- **Delete URL:**
  ```bash
  DELETE https://api.opsorbit.me/deleteurl/{id}
  ```
  - **Request Header:**
    ```bash
    Authorization: Bearer <idToken>
    ```

## Authentication:

1. **Sign Up:**
   - Endpoint: `https://api.opsorbit.me/signup`
   - Register a new user to obtain credentials.

2. **Login:**
   - Endpoint: `https://api.opsorbit.me/login`
   - Use the obtained credentials to log in and get the `idToken`.
  
3. **Authorization:**
   - Use the `idToken` as a Bearer token for authorized endpoints (`/createurl`, `/geturl`, `/deleteurl`).
  

## iOS App

The iOS app is developed using Swift and SwiftUI. It interacts with the serverless API to manage shortened URLs.

## Features

  - **Create Shortened URLs:** Use the `/createurl` API ednpoint along with baseurl to create new shortened URLs.
  - **Retrieve URLs:** Display the list of URLs created by the user by triggering the `/geturl` API endpoint in an interactive SwiftUI View with Glass Effect.
  - **Delete URLs:** Delete specific URLs using their ID that stored in DynamoDB.
  - **View:** Implemented Dark and light mode toggle and smooth animantion between pages and Glass Effect in `DeletedView` and `PreviouslyCreatedView` page view.


## Instructions for iOS App

1. **Move to Project Directory:**
   ```bash
   cd SwiftLink
   ```

2. **Open the project in Xcode:**
   ```bash
   open SwiftLink.xcodeproj
   ```

3. Open the `ContentView.Swift` file in `SwiftLink` directory to get the UI Structure directly and navigate to other pages. 

4. **Build and Run the App:**
   - Build and run the app on your preferred simulator or physical device.

## Contributing

Feel free to contribute to this project by submitting issues or pull requests. Your feedback and contributions are highly appreciated.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
