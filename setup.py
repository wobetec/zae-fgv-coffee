import os
import gdown


def download_file_from_google_drive(file_id, destination):
    """
    Downloads a file from Google Drive.
    Args:
        file_id (str): The ID of the file on Google Drive.
        destination (str): The local file path to save the downloaded file.
    """
    url = f"https://drive.google.com/uc?id={file_id}"
    print(f"\tDownloading file to {destination}")

    if os.path.exists(destination):
        print("\t\tFile already exists.")
        return
    try:
        gdown.download(url, destination, quiet=True)
        print("\t\tDownload completed.")
    except Exception as e:
        print(f"\t\tAn error occurred while downloading the file: {e}")


def setup_envs():
    """
    Sets up the environment variables.
    """
    def write_env(env: dict, path: str):
        with open(path, 'w') as f:
            for key, value in env.items():
                f.write(f'{key}="{value}"\n')

    backend_env = {
        'DJANGO_HOST': "0.0.0.0",
        'DJANGO_PORT': "8080",
        'GOOGLE_CLOUD_PROJECT': "zae-fgv-coffee",
        'ENV': 'DEV',
    }

    frontend_env = {
        'DJANGO_HOST': "localhost",
        'DJANGO_PORT': "8080",
        'GOOGLE_CLOUD_PROJECT': "zae-fgv-coffee",
    }

    write_env(backend_env, './backend/.env')
    write_env(frontend_env, './app/.env')


def main():
    print('Setting up the token file')
    download_file_from_google_drive('1QHSFgow-02oGYMuPlvcnYdON0kN1w1h_', './backend/app/tokens/zae-fgv-coffee-firebase-adminsdk.json')
    download_file_from_google_drive('1CP5KGfUN24sohAlld80WAllOpzjHEw6O', './app/android/app/google-services.json')

    print('Setting up the environment variables')
    setup_envs()


if __name__ == "__main__":
    main()
