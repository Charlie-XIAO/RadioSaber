#!/usr/bin/python3

import os

import matplotlib.pyplot as plt
import pandas as pd

INPUT_DIR = "../../src/flows/application/Trace"
OUTPUT_DIR = "results"
OUTPUT_TYPE = "png"


def read_data(filename):
    df = pd.read_csv(
        filename, sep="\t", header=None, names=["Index", "Type", "Time", "PacketSize"]
    )
    df["Time"] = df["Time"] // 1000  # convert to seconds
    df["PacketSize"] = df["PacketSize"] / (8 * 1000)  # convert to througput in Kbps

    # Sum PacketSize within each second to get Throughput
    df = df.groupby("Time")["PacketSize"].sum().reset_index()
    df.rename(columns={"PacketSize": "Throughput"}, inplace=True)
    return df


def plot_data(df, filename):
    plt.figure()
    plt.bar(df["Time"], df["Throughput"], width=0.5)
    plt.title(filename)
    plt.xlabel("Time (s)")
    plt.ylabel("Throughput (Kbps)")
    plt.savefig(os.path.join(OUTPUT_DIR, f"{filename}.{OUTPUT_TYPE}"))


if __name__ == "__main__":
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    for filename in os.listdir(INPUT_DIR):
        if filename.endswith(".dat"):
            df = read_data(os.path.join(INPUT_DIR, filename))
            plot_data(df, filename)
