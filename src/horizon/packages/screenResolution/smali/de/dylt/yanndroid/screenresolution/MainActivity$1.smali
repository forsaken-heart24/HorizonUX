.class Lde/dylt/yanndroid/screenresolution/MainActivity$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/widget/RadioGroup$OnCheckedChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lde/dylt/yanndroid/screenresolution/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

.field final synthetic val$resolution_apply:Lcom/google/android/material/button/MaterialButton;

.field final synthetic val$resolution_high:Lcom/google/android/material/radiobutton/MaterialRadioButton;

.field final synthetic val$resolution_low:Lcom/google/android/material/radiobutton/MaterialRadioButton;

.field final synthetic val$resolution_medium:Lcom/google/android/material/radiobutton/MaterialRadioButton;

.field final synthetic val$resolution_summary:Landroid/widget/TextView;


# direct methods
.method constructor <init>(Lde/dylt/yanndroid/screenresolution/MainActivity;Lcom/google/android/material/radiobutton/MaterialRadioButton;Lcom/google/android/material/radiobutton/MaterialRadioButton;Lcom/google/android/material/radiobutton/MaterialRadioButton;Lcom/google/android/material/button/MaterialButton;Landroid/widget/TextView;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010,
            0x1010,
            0x1010,
            0x1010,
            0x1010
        }
        names = {
            "this$0",
            "val$resolution_low",
            "val$resolution_medium",
            "val$resolution_high",
            "val$resolution_apply",
            "val$resolution_summary"
        }
    .end annotation

    .line 136
    iput-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    iput-object p2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_low:Lcom/google/android/material/radiobutton/MaterialRadioButton;

    iput-object p3, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_medium:Lcom/google/android/material/radiobutton/MaterialRadioButton;

    iput-object p4, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_high:Lcom/google/android/material/radiobutton/MaterialRadioButton;

    iput-object p5, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_apply:Lcom/google/android/material/button/MaterialButton;

    iput-object p6, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_summary:Landroid/widget/TextView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/RadioGroup;I)V
    .locals 1
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x0,
            0x0
        }
        names = {
            "group",
            "checkedId"
        }
    .end annotation

    .line 139
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_low:Lcom/google/android/material/radiobutton/MaterialRadioButton;

    sget-object v0, Landroid/graphics/Typeface;->DEFAULT:Landroid/graphics/Typeface;

    invoke-virtual {p1, v0}, Lcom/google/android/material/radiobutton/MaterialRadioButton;->setTypeface(Landroid/graphics/Typeface;)V

    .line 140
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_medium:Lcom/google/android/material/radiobutton/MaterialRadioButton;

    sget-object v0, Landroid/graphics/Typeface;->DEFAULT:Landroid/graphics/Typeface;

    invoke-virtual {p1, v0}, Lcom/google/android/material/radiobutton/MaterialRadioButton;->setTypeface(Landroid/graphics/Typeface;)V

    .line 141
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_high:Lcom/google/android/material/radiobutton/MaterialRadioButton;

    sget-object v0, Landroid/graphics/Typeface;->DEFAULT:Landroid/graphics/Typeface;

    invoke-virtual {p1, v0}, Lcom/google/android/material/radiobutton/MaterialRadioButton;->setTypeface(Landroid/graphics/Typeface;)V

    .line 143
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_apply:Lcom/google/android/material/button/MaterialButton;

    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    iget v0, v0, Lde/dylt/yanndroid/screenresolution/MainActivity;->current_resolution:I

    if-eq v0, p2, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p1, v0}, Lcom/google/android/material/button/MaterialButton;->setEnabled(Z)V

    .line 144
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    iput p2, p1, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    packed-switch p2, :pswitch_data_0

    goto :goto_1

    .line 152
    :pswitch_0
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_summary:Landroid/widget/TextView;

    const p2, 0x7f0f0065

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(I)V

    .line 153
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_medium:Lcom/google/android/material/radiobutton/MaterialRadioButton;

    sget-object p2, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {p1, p2}, Lcom/google/android/material/radiobutton/MaterialRadioButton;->setTypeface(Landroid/graphics/Typeface;)V

    goto :goto_1

    .line 148
    :pswitch_1
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_summary:Landroid/widget/TextView;

    const p2, 0x7f0f006a

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(I)V

    .line 149
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_low:Lcom/google/android/material/radiobutton/MaterialRadioButton;

    sget-object p2, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {p1, p2}, Lcom/google/android/material/radiobutton/MaterialRadioButton;->setTypeface(Landroid/graphics/Typeface;)V

    goto :goto_1

    .line 156
    :pswitch_2
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_summary:Landroid/widget/TextView;

    const p2, 0x7f0f0070

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(I)V

    .line 157
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$1;->val$resolution_high:Lcom/google/android/material/radiobutton/MaterialRadioButton;

    sget-object p2, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {p1, p2}, Lcom/google/android/material/radiobutton/MaterialRadioButton;->setTypeface(Landroid/graphics/Typeface;)V

    :goto_1
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x7f08012e
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
