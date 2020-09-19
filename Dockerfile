# Based on: https://github.com/Azure/MachineLearningNotebooks/blob/master/Dockerfiles/1.0.8/Dockerfile

FROM continuumio/miniconda:4.5.11

# Install Tools
RUN apt-get update && apt-get upgrade -y && apt-get install -y git openssh-server nkf vim less wget curl

# create a new conda environment named azureml
RUN conda create -n laptime -y -q Python=3.8.3

# install additional packages used by sample notebooks. this is optional
RUN ["/bin/bash", "-c", "source activate laptime && conda install -y tqdm cython matplotlib scikit-learn pyodbc"]

# install other library
RUN ["/bin/bash", "-c", "source activate laptime && pip install pandas seaborn lightgbm scipy statsmodels mlxtend optuna xgboost CatBoost tensorflow keras jpholiday joblib"]

# install prophet
RUN ["/bin/bash", "-c", "source activate laptime && conda install -c conda-forge fbprophet"]

# generate jupyter configuration file
RUN ["/bin/bash", "-c", "source activate laptime && mkdir ~/.jupyter && cd ~/.jupyter && jupyter notebook --generate-config"]

RUN echo "c.NotebookApp.password = u'sha1:7cf465f0ed5c:26aa862a0ba75cb7eee8ae3e958bbfa654565a3d'" >> ~/.jupyter/jupyter_notebook_config.py

# open up port 8888 on the container
EXPOSE 8888

### Setup ssh
RUN mkdir /var/run/sshd
RUN echo "root:root" | chpasswd
RUN sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22

# start Jupyter notebook server on port 8888 when the container starts
ADD ./start.sh /
 ADD ./packages.pth /opt/conda/envs/laptime/lib/python3.8/site-packages/
RUN chmod +x /start.sh
CMD ["/start.sh"]