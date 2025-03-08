
document.addEventListener("DOMContentLoaded", function () {
    var deleteButton = document.getElementById("delete");
    var newButton = document.getElementById("new");
    var closeButton = document.getElementById("cancelDelete");

    if (deleteButton) {
        deleteButton.addEventListener("click", function () {
            document.getElementById("deleteModal").classList.remove("hidden");
        });
    }

    if (closeButton) {
        closeButton.addEventListener("click", function () {
            document.getElementById("deleteModal").classList.add("hidden");
        });
    }
});

setTimeout(function () {
    var noticeElement = document.getElementById("notice");
    if (noticeElement) {
        noticeElement.style.opacity = "0";
        setTimeout(function () {
            noticeElement.style.display = "none";
        }, 500);
    }
}, 3000);

function showDeleteModal(deletePath) {
    const modal = document.getElementById("deleteModal");
    const deleteFormContainer = document.getElementById("deleteFormContainer");

    const formHTML = `
    <form action="${deletePath}" method="post" class="inline">
    <input type="hidden" name="_method" value="delete">
    <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
    <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 focus:outline-none ml-2">
    Delete
    </button>
    </form>
    `;

    deleteFormContainer.innerHTML = formHTML;
    modal.classList.remove("hidden");
}

document.getElementById("cancelDelete").addEventListener("click", function () {
    document.getElementById("deleteModal").classList.add("hidden");
});

document.getElementById("deleteModal").addEventListener("click", function (e) {
    if (e.target === this) {
        this.classList.add("hidden");
    }
});

function showSlide() {
    event.target.closest("td")?.classList.contains("actions") &&
        event.stopPropagation();

    document.getElementById("employeeForm")
        .classList.add("show");

    const employeeForm = document
        .getElementById("employeeForm")
        .querySelector(".p-0");

    const formHTML = `
    <% if @employee.nil? %>
    <% @employee = Employee.new %>
    <% end %>
    <%= render "form", employee: @employee %>
    `;

    employeeForm.innerHTML = formHTML;
    addOverlay();
}

function closeEmployeeDetails() {
    document.getElementById("employeeForm").classList.add("translate-x-full");

    removeOverlay();
}

function addOverlay() {
    const overlay = document.createElement("div");
    overlay.id = "detailsOverlay";
    overlay.className = "fixed inset-0 bg-black bg-opacity-50 z-40";
    overlay.onclick = closeEmployeeDetails;
    document.body.appendChild(overlay);
}

function removeOverlay() {
    const overlay = document.getElementById("detailsOverlay");
    if (overlay) {
        overlay.remove();
        document.getElementById("employeeForm").classList.remove("show");
    }
}

document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
        closeEmployeeDetails();
    }
});

function closeEmployeeForm() {
    document.getElementById("employeeForm").classList.remove("show");
    removeOverlay();
}

document.getElementById("closeForm").addEventListener("click", closeEmployeeForm);

function editEmployee(employeeId) {
    event.target.closest("td")?.classList.contains("actions") &&
        event.stopPropagation();

    document
        .getElementById("employeeForm")
        .classList.add("show");

    const employeeForm = document
        .getElementById("employeeForm")
        .querySelector(".p-0");

    fetch(`/chitoge/employees/${employeeId}/edit`, {
        headers: { "X-Requested-With": "XMLHttpRequest" },
    })
        .then((response) => {
            if (!response.ok) {
                throw new Error("Network response was not ok");
            }
            return response.text();
        })
        .then((formHTML) => {
            employeeForm.innerHTML = formHTML;
            addOverlay();
        })
        .catch((error) => console.error("Error fetching form:", error));
}

