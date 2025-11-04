# Red Hat OpenShift AI on Cisco AI POD

This repository provides scripts and notebooks for setting up and running PyTorch GPU training workloads on Red Hat OpenShift AI.

### Quick Start

To configure Red Hat OpenShift AI components for PyTorch training, run the setup script:

```bash
./rhoai-training-setup.sh
```

This script will:
- Enable hardware profiles for GPU nodes
- Configure hardware profiles for optimal GPU utilization
- Install necessary components using `install-components.sh`

### Prerequisites

Before running the setup script, ensure you have:
- Access to an OpenShift cluster
- OpenShift CLI (`oc`) installed and configured
- Proper authentication to the cluster (`oc login`)

### Training Configuration

After running the setup script, refer to **[TrainingGuidelines.md](TrainingGuidelines.md)** for detailed information on:

- **GPU Hardware-Specific Parameter Tuning**: The guide contains recommended parameter adjustments based on your GPU hardware (e.g., small GPUs ≤16GB vs. powerful GPUs like H100/H200/A100)
- Training parameter optimization for batch size, model size, image size, and other key parameters
- Multi-GPU training configuration
- Performance optimization tips

The training guidelines will help you adjust parameters such as:
- `BATCH_SIZE` - Optimize for your GPU memory capacity
- `MODEL_SIZE` - Choose appropriate model complexity
- `IMAGE_SIZE` - Adjust based on GPU compute capabilities
- `NUM_SAMPLES` and `EPOCHS` - Configure training duration
- And more...

### Additional Resources

- See `notebooks/gpu_training_demo.ipynb` for a complete PyTorch training example
- Review `install-components.sh` for detailed component installation options
