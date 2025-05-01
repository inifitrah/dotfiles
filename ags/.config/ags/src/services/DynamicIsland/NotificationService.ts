import { GLib, Variable } from "astal";
import Notifd from "gi://AstalNotifd";

class NotificationService {
  private static _instance: NotificationService;
  private notifd = Notifd.get_default();

  // Reactive state
  public latestNotification = Variable<Notifd.Notification | null>(null);
  public notifications = Variable<Notifd.Notification[]>([]);
  public hasNotifications = Variable<boolean>(false);

  private constructor() {
    // Initialize with current notifications
    this.updateNotifications();

    // Subscribe to notification events - hanya 'notified' yang tersedia
    this.notifd.connect("notified", this.handleNotified.bind(this));

    // Tidak ada signal 'dismissed' dan 'cleared', gunakan 'notified'
    // untuk update semua status notifikasi

    // Polling periodik sebagai alternatif untuk memeriksa notifikasi yang dihapus
    GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
      this.updateNotifications();
      return true; // kembalikan true agar tetap berjalan
    });
  }

  public static getInstance(): NotificationService {
    if (!NotificationService._instance) {
      NotificationService._instance = new NotificationService();
    }
    return NotificationService._instance;
  }

  private handleNotified(_, id: number) {
    const notification = this.notifd.get_notification(id);

    if (notification) {
      // Update latest notification
      this.latestNotification.set(notification);

      // Update notifications list
      this.updateNotifications();
    }
  }

  // Hapus handleDismissed dan handleCleared yang tidak tersedia

  private updateNotifications() {
    const allNotifications = this.notifd.get_notifications();
    const sortedNotifications = [...allNotifications].sort(
      (a, b) => b.time - a.time
    );

    this.notifications.set(sortedNotifications);
    this.hasNotifications.set(sortedNotifications.length > 0);

    // Ensure latest notification is up-to-date
    if (sortedNotifications.length > 0) {
      this.latestNotification.set(sortedNotifications[0]);
    } else {
      this.latestNotification.set(null);
    }
  }

  // Utility methods
  public dismissNotification(id: number) {
    const notification = this.notifd.get_notification(id);
    if (notification) {
      notification.dismiss();
      this.updateNotifications(); // update setelah dismiss
    }
  }

  public dismissLatest() {
    const notification = this.latestNotification.get();
    if (notification) {
      notification.dismiss();
      this.updateNotifications(); // update setelah dismiss
    }
  }

  public dismissAll() {
    const notifications = this.notifications.get();
    notifications.forEach((notification) => {
      notification.dismiss();
    });
    this.updateNotifications(); // update setelah dismiss all
  }
}

// Export instance, bukan class
export default NotificationService.getInstance();
