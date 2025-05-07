import { Binding } from "astal";

declare module "astal/gtk3" {
  interface BaseProps {
    className?: string;
    [key: string]: any;
  }

  interface WindowProps extends BaseProps {
    children: any;
    gdkmonitor?: any;
    name?: string;
    visible?: boolean;
    exclusivity?: any;
    anchor?: any;
    layer?: any;
    margin?: number | Binding<number>;
    onDestroy?: () => void;
  }

  interface EventBoxProps extends BaseProps {
    children: any;
    onHover?: () => void;
    onHoverLost?: () => void;
    onClick?: () => void;
  }

  interface BoxProps extends BaseProps {
    children: any;
    hpack?: any;
  }
}
