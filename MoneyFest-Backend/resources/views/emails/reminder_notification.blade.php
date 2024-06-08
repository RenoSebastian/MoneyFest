<!DOCTYPE html>
<html>

<head>
    <title>Instalment Reminder Notification</title>
</head>

<body>
    <h1>Reminder for Instalment</h1>
    <p>Dear {{ $reminder->user->name }},</p>
    <p>This is a reminder for your instalment with the following details:</p>
    <ul>
        <li><strong>Deadline:</strong> {{ $reminder->deadline }}</li>
        <li><strong>Frequency:</strong> {{ $reminder->frequency }}</li>
        <li><strong>Notes:</strong> {{ $reminder->notes }}</li>
    </ul>
    <p>Please ensure to meet your instalment deadlines to avoid penalties.</p>
</body>

</html>