package com.listviewqml.contact;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import org.qtproject.qt.android.bindings.QtActivity;
import android.provider.ContactsContract;
import android.os.Bundle;

public class MainActivity extends QtActivity
{
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("Service Started", "Oncreate");
    }

    public String readContactDetails(String contactDetails) {
        String[] splitDetails =  contactDetails.split(",",3);
        String name = splitDetails[0];
        String email = splitDetails[1];
        String phone = splitDetails[2];

        Intent intent = new Intent(ContactsContract.Intents.Insert.ACTION);
        intent.setType(ContactsContract.RawContacts.CONTENT_TYPE);

        intent.putExtra(ContactsContract.Intents.Insert.NAME, name);
        intent.putExtra(ContactsContract.Intents.Insert.EMAIL, email);
        intent.putExtra(ContactsContract.Intents.Insert.PHONE, email);
        startActivity(intent);
        return contactDetails;
    }
}