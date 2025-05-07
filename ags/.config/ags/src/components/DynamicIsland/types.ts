import { Variable, GLib } from "astal";
import { Widget } from "astal/gtk3";

export type DynamicIslandState = {
  isHovered: boolean;
  isExpanded: boolean;
  isDashboardOpen: boolean;
  activeProviderId: string | null;
};

export type Provider = {
  id: string;
  priority: number;
  condition: () => boolean;
  render: () => JSX.Element;
};

export class DynamicIslandStore {
  private state: Variable<DynamicIslandState>;
  private timeoutId: number | null = null;

  constructor() {
    this.state = Variable<DynamicIslandState>({
      isHovered: false,
      isExpanded: false,
      isDashboardOpen: false,
      activeProviderId: null,
    });
  }

  get = () => this.state.get();

  set = (newState: Partial<DynamicIslandState>) => {
    this.state.set({ ...this.state.get(), ...newState });
  };

  setHovered = (value: boolean) => {
    this.set({ isHovered: value });
  };

  setExpanded = (value: boolean) => {
    this.set({ isExpanded: value });
    if (!value) {
      this.set({ isDashboardOpen: false });
    }
  };

  setDashboardOpen = (value: boolean) => {
    this.set({ isDashboardOpen: value });
    if (value) {
      this.setExpanded(true);
    }
  };

  setActiveProvider = (id: string | null) => {
    this.set({ activeProviderId: id });
  };

  setupAutoCollapse = (duration: number = 3000) => {
    if (this.timeoutId !== null) {
      GLib.source_remove(this.timeoutId);
      this.timeoutId = null;
    }

    this.timeoutId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, duration, () => {
      this.setExpanded(false);
      this.timeoutId = null;
      return GLib.SOURCE_REMOVE;
    });
  };

  destroy = () => {
    if (this.timeoutId !== null) {
      GLib.source_remove(this.timeoutId);
      this.timeoutId = null;
    }
    this.state.drop();
  };

  getStateBinding = () => {
    return this.state;
  };
}
