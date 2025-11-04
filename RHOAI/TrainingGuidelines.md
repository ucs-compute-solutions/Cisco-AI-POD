# PyTorch GPU Training Demo on OpenShift AI

This repository demonstrates how to run a **synthetic PyTorch training job** on Red Hat OpenShift AI using GPU nodes.  
It’s designed to help validate GPU utilization, scaling, and training efficiency across **1–N GPUs**, with tunable parameters and live utilization sampling.

---

## ✨ Features

- **Self-contained synthetic training** (no data download)
- **Multi-GPU aware** (auto-detects GPUs, uses DataParallel)
- **Progress bar per epoch** with live throughput and loss
- **Tunable workload intensity** for benchmarking
- **Explains constant GPU memory behavior**
- **Ready for OpenShift AI Jupyter Workbench**

---

## Recommended Parameter Adjustments by GPU Type

| **Parameter**              | **Purpose**                                | **Default** | **Recommended for Small GPU (≤16 GB)** | **Recommended for Powerful GPU (H100/H200/A100)** | **Notes**                                                                   |
| -------------------------- | ------------------------------------------ | ----------- | -------------------------------------- | ------------------------------------------------- | --------------------------------------------------------------------------- |
| `IMAGE_SIZE`               | Synthetic image size (affects activations) | `224`       | **128** or **64**                      | **256 – 384**                                     | Larger input tensors increase compute and memory utilization.               |
| `BATCH_SIZE`               | Number of samples per step                 | `512`       | **32 – 64**                            | **1024 – 2048** (with AMP)                        | Most impactful knob for GPU utilization. Scale up until near 90–95% memory. |
| `MODEL_SIZE`               | Network depth/width                        | `"small"`   | **"tiny"**                             | **"base"** or **"large"**                         | Bigger models increase both FLOPs and VRAM use.                             |
| `NUM_SAMPLES`              | Total synthetic dataset size               | `200 000`   | **20 000 – 50 000**                    | **1 000 000 +**                                   | Longer training keeps GPUs busy and smooths utilization metrics.            |
| `EPOCHS`                   | Number of training epochs                  | `5`         | **3**                                  | **10 – 20**                                       | Run longer for more realistic benchmarking.                                 |
| `USE_AMP`                  | Mixed precision training                   | `True`      | ✅ **Keep True**                       | ✅ **Keep True or enable FP8** (if supported)     | AMP or FP8 keeps training efficient and stable.                             |
| `GRAD_ACCUM_STEPS`         | Gradient accumulation steps                | `1`         | **1 – 2**                              | **4 – 8**                                         | Accumulate gradients to emulate even larger global batches.                 |
| `VARY_BATCH_SIZE_SCHEDULE` | Batch size change per epoch                | `True`      | **False**                              | **True**                                          | Enables dynamic workload shifts for testing memory variance.                |
| `NUM_GPUS_TO_USE`          | GPUs used                                  | `None`      | **1**                                  | **All visible GPUs (8, 16 etc.)**                 | Use `torch.nn.DataParallel` or `torchrun` with DDP for distributed load.    |
| `AUGMENT_NOISE`            | Adds input randomness                      | `True`      | Optional                               | **True**                                          | Keeps loss non-constant and prevents overfitting in synthetic workloads.    |
