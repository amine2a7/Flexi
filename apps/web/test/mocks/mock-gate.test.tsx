// @vitest-environment jsdom
import { render, screen, waitFor } from '@testing-library/react';
import { Component, type ReactNode } from 'react';
import { describe, expect, it, vi } from 'vitest';

const startMocking = vi.fn<() => Promise<void>>();
vi.mock('@/mocks/browser', () => ({ startMocking: () => startMocking() }));

const { MockGate } = await import('@/mocks/mock-gate');

class Boundary extends Component<{ children: ReactNode }, { failed: boolean }> {
  override state = { failed: false };
  static getDerivedStateFromError(): { failed: boolean } {
    return { failed: true };
  }
  override render(): ReactNode {
    return this.state.failed ? <p>boundary</p> : this.props.children;
  }
}

describe('MockGate (development)', () => {
  it('renders nothing until the mock worker is ready, then the app', async () => {
    let release: () => void = () => undefined;
    startMocking.mockReturnValue(new Promise<void>((resolve) => (release = resolve)));
    render(
      <MockGate>
        <p>app</p>
      </MockGate>,
    );
    expect(screen.queryByText('app')).toBeNull();
    release();
    expect(await screen.findByText('app')).toBeTruthy();
  });

  it('surfaces a worker start failure to the error boundary instead of a blank page', async () => {
    startMocking.mockRejectedValue(new Error('worker failed'));
    const silence = vi.spyOn(console, 'error').mockImplementation(() => undefined);
    render(
      <Boundary>
        <MockGate>
          <p>app</p>
        </MockGate>
      </Boundary>,
    );
    await waitFor(() => {
      expect(screen.getByText('boundary')).toBeTruthy();
    });
    expect(screen.queryByText('app')).toBeNull();
    silence.mockRestore();
  });
});
