<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use App\Models\ReminderModel;


class ReminderNotification extends Mailable
{
    use Queueable, SerializesModels;

    public $reminder;

    public function __construct(ReminderModel $reminder)
    {
        $this->reminder = $reminder;
    }

    public function build()
    {
        return $this->subject('Instalment Reminder Notification')
                    ->view('emails.reminder_notification')
                    ->with([
                        'reminder' => $this->reminder,
                    ]);
    }
}