# DHCP Performance Testing

**DISCLAIMER: This is proof of concept only and should not be used as official guidance.**

### Instructions

- Use the steps below to validate DHCP performance.
- Credits and reference: [Kea DHCP4 Basic Performance Testing](https://www.youtube.com/watch?v=IW3eXTM9skc)
- All VMs are accessible via Serial Console. You can install Bastion for a better remote access experience.

Step 1 - Deploy DHCP Server and Client

[deploy.azcli](https://github.com/dmauser/azure-dhcp-perftest/blob/main/deploy.azcli)

Step 2 - Run DHCP performance tests on the DHCP Client

Here are some examples:

1. 10 DHCP requests/sec for 30 seconds duration.

```bash
sudo perfdhcp -r 10 -p 30 10.1.0.4
```

Expected output:
```bash
Running: perfdhcp -r 10 -p 30 10.1.0.4
Scenario: basic.
***Rate statistics***
Rate: 9.96665 4-way exchanges/second, expected rate: 10

***Malformed Packets***
Malformed packets: 0
***Statistics for: DISCOVER-OFFER***
sent packets: 299
received packets: 299
drops: 0
drops ratio: 0 %
orphans: 0
rejected leases: 0
non unique addresses: 0

min delay: 1.057 ms
avg delay: 1.633 ms
max delay: 3.923 ms
std deviation: 0.377 ms
collected packets: 0

***Statistics for: REQUEST-ACK***
sent packets: 299
received packets: 299
drops: 0
drops ratio: 0.000 %
orphans: 0
rejected leases: 0
non unique addresses: 0

min delay: 0.623 ms
avg delay: 1.109 ms
max delay: 6.382 ms
std deviation: 0.591 ms
collected packets: 0
```

2. 1000 DHCP requests/sec for 60 seconds duration.

```bash
sudo perfdhcp -r 1000 -p 60 10.1.0.4
```

Expected output:
```bash
Running: perfdhcp -r 1000 -p 60 10.1.0.4
Scenario: basic.
***Rate statistics***
Rate: 999.883 4-way exchanges/second, expected rate: 1000

***Malformed Packets***
Malformed packets: 0
***Statistics for: DISCOVER-OFFER***
sent packets: 59999
received packets: 59995
drops: 4
drops ratio: 0.00666678 %
orphans: 0
rejected leases: 0
non unique addresses: 0

min delay: 0.251 ms
avg delay: 1.460 ms
max delay: 40.808 ms
std deviation: 3.633 ms
collected packets: 4

***Statistics for: REQUEST-ACK***
sent packets: 59995
received packets: 59993
drops: 2
drops ratio: 0.003 %
orphans: 0
rejected leases: 0
non unique addresses: 0

min delay: 0.260 ms
avg delay: 1.393 ms
max delay: 40.284 ms
std deviation: 3.445 ms
collected packets: 1
```

### Notes:

- Use the **top** command on DHCP Server to check CPU utilization (kea-dhp4 process).
- The VMs use Standard DS1 v2 (1 vcpu, 3.5 GiB memory). You can Resize DHCP Server to improve the results if you get a high CPU or many DHCP request/response drops.
