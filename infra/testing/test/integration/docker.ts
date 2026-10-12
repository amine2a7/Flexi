import { getContainerRuntimeClient } from 'testcontainers';

/** Host IPs on which Docker publishes the ports of a container (public Testcontainers API). */
export async function publishedHostIps(containerId: string): Promise<string[]> {
  const client = await getContainerRuntimeClient();
  const info = await client.container.inspect(client.container.getById(containerId));
  const ips = Object.values(info.NetworkSettings.Ports)
    .flatMap((bindings) => bindings)
    .map((binding) => binding.HostIp);
  return [...new Set(ips)];
}
