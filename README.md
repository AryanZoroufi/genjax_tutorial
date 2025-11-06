## 📦 Installation

### Prerequisites
- **System**: The code is currently tested only on **Linux**.
- **Hardware**: An NVIDIA GPU is necessary to execute the code. Some foundation models (e.g. Trellis) require at least 24gb VRAM. The code has been verified on NVIDIA H100 GPUs. 
- **Software**:   
  - The [CUDA Toolkit](https://developer.nvidia.com/cuda-toolkit-archive) is needed to compile certain submodules. The code has been tested with CUDA version 12.9.  
  - Python version 3.10 or higher is required. The code has been tested with Python 3.12.

### Installation Steps

0. **Install Pixi** (see [Pixi's installation guide](https://pixi.sh/latest/installation/) for details):
    ```sh
    curl -fsSL https://pixi.sh/install.sh | sh
    ```

1. **Clone the repository**:
    ```sh
    git clone https://github.com/AryanZoroufi/genjax_tutorial.git
    cd genjax_tutorial
    ```

2. **Install dependencies** (this step may take a few minutes):
    ```sh
    pixi run setup
    ```

<!-- 3. **Connect to your Hugging Face account**:
    ```sh
    huggingface-cli login
    ```
    Then follow the steps in the terminal.

4. **Request access to Flux**: 
   - Go to [this link](https://huggingface.co/black-forest-labs/FLUX.1-Fill-dev)
   - Login to your Hugging Face account 
   - Click "Agree" to request access to the repository -->

## 💡 Usage

1. **Activate the GPU environment**:
    ```sh
    pixi shell -e gpu
    ```

2. **Run Python scripts** within the environment

3. **For Jupyter Notebook**, run the following command inside a terminal with the GPU environment activated:
    ```sh
    jupyter notebook
    ```
    Use the provided link to access the notebook. **Note**: You will encounter errors if you select the pixi environment directly as the Python interpreter in your Jupyter notebook interface.