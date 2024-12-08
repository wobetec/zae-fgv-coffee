# ZAE FGV Coffee

Project developed during the Software Engineering course at FGV 24.2, aimed at applying knowledge of Scrum and Design Patterns.

## Team Members

- [Esdras Cavalcanti](https://github.com/wobetec)
- [Zuilho Segundo](https://github.com/ZuilhoSe)
- [Marcelo Angelo](https://github.com/MasFz)
- [Anderson Falcão](https://github.com/falcaoanderson)

## Application

The system is divided into:

- Backend: API developed in Django `/backend`
- Frontend: Interface developed in Flutter `/app`

Each part needs to be executed separately when running locally. First you need to start backend and then frontend.

## Execution

### Locally

Within each directory, there is a README with execution instructions. However, to load the authentication tokens and the required `.env` files, run:

    python setup.py

Make sure that you have `gdown` installed. If not, install it with:

    pip install gdown

### Deployment

The application deployment has not been performed yet. However, the goal is to use GitHub Actions to automate the deployment process. Both the backend and the frontend (web) will be hosted on [Vercel](https://vercel.com). For the Android and Windows frontend, we plan to list the latest build version here on GitHub, so it can be downloaded and installed on the respective devices.
